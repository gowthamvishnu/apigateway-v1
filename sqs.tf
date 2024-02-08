
variable "aws_region" {
  description = "The AWS region to create things in."
  default = "us-east-1" 
}

variable "api_gateway_iam_role" {
  description = "IAM Role for API Gateway"
  #default = "arn:aws:iam::205380336443:instance-profile/db_ec2_role"
}



data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


resource "aws_sqs_queue" "queue1" {
  count       = local.list_1_extra_count
  name = "${element(local.list1, length(local.list2) + count.index)}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10


}

resource "aws_sqs_queue" "queue2" {
  count       = local.list_2_extra_count
  name = "${element(local.list2, length(local.list3) + count.index)}"

  #name        = element(local.list2[length(local.list3) + count.index], count.index)
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

 
}

resource "aws_sqs_queue" "queue3" {
  count       = length(local.nested_resources)
  name        = "${element(flatten(local.list3), count.index)}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

 
}


resource "aws_sqs_queue_policy" "queue1_policy1" {
 count       = local.list_1_extra_count
  queue_url  = aws_sqs_queue.queue1[count.index].id
  policy     = jsonencode({
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
      {
        "Sid": "SQS",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": [
            "SQS:*"
        ],
        "Resource": aws_sqs_queue.queue1[count.index].arn
      }
    ]
  })
}


resource "aws_sqs_queue_policy" "queue2_policy2" {
   count       = local.list_2_extra_count
  queue_url  = aws_sqs_queue.queue2[count.index].id
  policy     = jsonencode({
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
      {
        "Sid": "SQS",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": [
            "SQS:*"
        ],
        "Resource": aws_sqs_queue.queue2[count.index].arn
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "queue3_policy3" {
count       = length(local.nested_resources)
  queue_url  = aws_sqs_queue.queue3[count.index].id
  policy     = jsonencode({
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
      {
        "Sid": "SQS",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": [
            "SQS:*"
        ],
        "Resource": aws_sqs_queue.queue3[count.index].arn
      }
    ]
  })
}




