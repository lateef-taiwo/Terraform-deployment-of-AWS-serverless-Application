# Create Lambda Function
resource "aws_lambda_function" "wild_rides_lambda" {
  function_name = "wild-rides-lambda-function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  role          = aws_iam_role.lambda_iam_role.arn
  memory_size   = 128
  timeout       = 60
  s3_bucket     = "wild-rides-bucket-0056"
  s3_key        = "lambda-function.zip"
  depends_on    = [aws_iam_role.lambda_iam_role, aws_s3_bucket.s3-bucket]

  environment {
    variables = {
      TABLE_NAME = "Wild-Rides-Table"
    }
  }
}

# Invoke Lambda Function
# resource "aws_lambda_invocation" "invoke_test_event" {
#   function_name = aws_lambda_function.wild_rides_lambda.function_name
#   input         = <<EOT
#  {
#     "path": "/ride",
#     "httpMethod": "POST",
#     "headers": {
#         "Accept": "*/*",
#         "Authorization": "eyJraWQiOiJLTzRVMWZs",
#         "content-type": "application/json; charset=UTF-8"
#     },
#     "queryStringParameters": null,
#     "pathParameters": null,
#     "requestContext": {
#         "authorizer": {
#             "claims": {
#                 "cognito:username": "the_username"
#             }
#         }
#     },
#     "body": "{\"PickupLocation\":{\"Latitude\":47.6174755835663,\"Longitude\":-122.28837066650185}}"
# }

#   EOT

#   depends_on = [aws_lambda_function.wild_rides_lambda]
# }

# Capture Lambda output
output "lambda_output" {
  value = aws_lambda_invocation.invoke_test_event.result
}

