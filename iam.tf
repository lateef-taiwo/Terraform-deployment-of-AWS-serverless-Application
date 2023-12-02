# resource "aws_iam_user" "serverless" {
#   name = "serverless"  
# }

# Import the existing IAM user
data "aws_iam_user" "serverless" {
  user_name = "serverless"
}

resource "aws_iam_user_policy_attachment" "attach_codecommit_power_user" {
  user       = data.aws_iam_user.serverless.user_name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_policy" "codecommit_policy" {
  name = "codecommit_policy"
  user = data.aws_iam_user.serverless.user_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:GitPull",
        "codecommit:GitPush"
      ],
      "Resource": "arn:aws:codecommit:us-east-1:005654795190:wild-rides-repo"
    }
  ]
}
POLICY
}

# resource "aws-iam-role" "wild-rides" {
  
# }

# resource "aws_iam_role" "iam_role_lambda" {
#   name = var.role-1

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

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