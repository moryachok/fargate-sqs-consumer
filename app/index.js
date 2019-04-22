const environment = process.env.NODE_ENV || 'development';
const SQS = require('aws-sdk/clients/sqs');
const log = require('lambda-log');

let sqsParams = {
  apiVersion: '2012-11-05',
  retryDelayOptions: {
    base: 1000
  }
}

log.options.debug = (process.env.DEBUG==1)

if (environment=="development") {
  require('dotenv').config({ path: 'development.env' })
  if (process.env.SQS_ENDPOINT) {
    sqsParams.endpoint = process.env.SQS_ENDPOINT
  }
  if (process.env.REGION) {
    sqsParams.region = process.env.REGION
  }
}

var sqs = new SQS(sqsParams);

var params = {
  QueueUrl: process.env.SQS_URL,
  MaxNumberOfMessages: 1,
  VisibilityTimeout: 30,
  WaitTimeSeconds: 5
};


function loop(){
  log.info("loop called...");
  sqs.receiveMessage(params).promise().then((data)=>{
    log.debug(data);
    if (data.Messages) {
      log.info("body=" + data.Messages[0].Body);
      let receiptHandle = data.Messages[0].ReceiptHandle;
      return sqs.deleteMessage({QueueUrl: process.env.SQS_URL, ReceiptHandle:receiptHandle}).promise()
    }else{
      log.info("no messages, skipping....")
      return Promise.resolve()
    }
  }).then((data)=>{
    if (data) log.info("deleteMessage()", data);
    loop()
  }).catch((err)=>{
    log.error(err);
  })
}

loop()


