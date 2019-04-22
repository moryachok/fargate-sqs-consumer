variable "region" { default = "us-east-1" }

variable "subnets" { 
  type = "list" 
}

variable "vpc_id" {
  type = "string"
}

variable "image" {
  type = "string"
}

variable "flags_create" {
  default = 0
}

variable "cluster_name" {
  type = "string"
  default = "fargate-sqs-consumer"
}

variable "execution_role_arn" {
  type = "string"
}

variable "task_role_arn" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "my_ip" {
  type = "string"
  description = "ip for security groups whitelists"
}

variable "enabled_metrics" {
  type = "list"
  default = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}