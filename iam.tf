# Import the existing IAM user
data "aws_iam_user" "serverless" {
  user_name = "serverless"
}

resource "aws_iam_user_policy_attachment" "attach_codecommit_power_user" {
  user       = data.aws_iam_user.serverless.user_name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

# Define a service role for amplify
resource "aws_iam_role" "iam_role_amplify" {
  name = "amplify-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "amplify-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  role       = aws_iam_role.iam_role_amplify.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
}


resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_execution_role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_iam_role.name
}

#Attachment of a Managed AWS IAM Policy for Lambda sqs execution
resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_queue_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.lambda_iam_role.name
}

# #Attachment of a Managed AWS IAM Policy for Lambda S3 read access
# resource "aws_iam_role_policy_attachment" "lambda_basic_s3_read_access_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ReadOnlyAccess"
#   role       = aws_iam_role.lambda_iam_role.name
# }

resource "aws_iam_role_policy_attachment" "lambda_basic_s3_read_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.lambda_iam_role.name
}


resource "aws_iam_policy" "dynamodb_write_policy" {
  name        = "dynamodb_write_policy"
  description = "Policy allowing write access to DynamoDB table"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:005654795190:table/Wild-Rides-Table"
    }
  ]
}
EOF

depends_on = [ aws_dynamodb_table.Wild-Rides-Details-db ]
}

resource "aws_iam_role_policy_attachment" "dynamodb_write_attachment" {
  policy_arn = aws_iam_policy.dynamodb_write_policy.arn
  role       = aws_iam_role.lambda_iam_role.name
}


# resource "aws_iam_role" "iam_role_amplify" {
#   name = var.role-2
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "amplify.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

#