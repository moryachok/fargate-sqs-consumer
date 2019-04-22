provider "aws" {
  region = "${var.region}"
}

data "template_file" "task_consumer" {
  template = "${file("${path.module}/task_definitions/consumer.json")}"

  vars {
    region = "${var.region}"
    image = "${var.image}"
    cluster_name = "${var.cluster_name}"
    sqs_url = "${aws_sqs_queue.production.id}"
  }
}

resource "aws_security_group" "ecs" {
  count = "${var.flags_create}"
  name = "ecs-clusters-${var.cluster_name}"
  description = "ecs-clusters-${var.cluster_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################################################
###  ECS RELATED RESOURCES  ####################################
################################################################

resource "aws_ecs_cluster" "production" {
  count = "${var.flags_create}"
  name = "${var.cluster_name}"
}

resource "aws_sqs_queue" "production" {
  count = "${var.flags_create}"
  name = "production-fargate"
  message_retention_seconds = 86400
  visibility_timeout_seconds = "600"
  tags = {
    Environment = "production"
  }
}

resource "aws_ecs_task_definition" "consumer" {
  count = "${var.flags_create}"
  family = "node"
  container_definitions = "${data.template_file.task_consumer.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  memory = "512"
  cpu = "256"
  execution_role_arn = "${var.execution_role_arn}"
  task_role_arn = "${var.task_role_arn}"
}

resource "aws_ecs_service" "consumer" {
  count = "${var.flags_create}"
  name = "node"
  cluster = "${aws_ecs_cluster.production.id}"
  task_definition = "${aws_ecs_task_definition.consumer.arn}"
  launch_type = "FARGATE"

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  desired_count = 1

  network_configuration {
    subnets = "${var.subnets}"
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "group" {
  count = "${var.flags_create}"
  name = "/ecs/${var.cluster_name}"

  tags = {
    Environment = "production"
    Application = "${var.cluster_name}"
  }
}
