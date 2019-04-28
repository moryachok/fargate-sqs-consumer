# AWS Fargate SQS Consumer

This repo will help you to create a cluster of Docker containers using AWS Fargate. 
The app which running in Docker is simple NodeJS application which consumes messages from AWS SQS service.

In repo app you will find all the required components not just to run it locally, but even deploy it to your AWS account with couple of simple commands.

### Directory structure

    ├── app                   # nodejs app with package.json included
    ├── terraform             # terraform configuration for creating infrastructure in AWS account


### Useful Links

AWS Fargate - getting started
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted.html

AWS SQS - getting started
https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-tutorials.html

Terraform
https://www.terraform.io/docs/index.html


## Prerequisites

* Docker - Install Docker on your system by going to this URL https://docs.docker.com/install/
* Terraform - install terraform https://www.terraform.io/downloads.html


## Installing

You need to clone this repo to any path at your local machine

```
git clone https://github.com/moryachok/fargate-sqs-consumer.git
```

## Running Locally

```
aws sqs send-message \
   --queue-url http://localhost:9324/queue/development-fargate \
   --message-body "demo-message" \
   --region elasticmq --endpoint-url http://localhost:9324
```

## Running on AWS

### Deploy to ECR

```
docker build -t fargate-sqs-consumer .
docker tag fargate-sqs-consumer:latest xxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/fargate-sqs-consumer:latest
$(aws ecr get-login --no-include-email --region us-east-1)
docker push xxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/fargate-sqs-consumer:latest
```

### Creating AWS Infrastructure with terraform




