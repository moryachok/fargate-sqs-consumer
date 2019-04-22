aws sqs send-message \
   --queue-url http://localhost:9324/queue/development-fargate \
   --message-body "demo-message" \
   --region elasticmq --endpoint-url http://localhost:9324




$(aws ecr get-login --no-include-email --region us-east-1)

docker build -t fargate-sqs-consumer .

docker tag fargate-sqs-consumer:latest xxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/fargate-sqs-consumer:latest

docker push xxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/fargate-sqs-consumer:latest