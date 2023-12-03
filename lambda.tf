resource "aws_lambda_function" "wild_rides_lambda" {
  function_name    = "wild-rides-lambda-function"
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  filename         = "/home/savvytech/Documents/DevOps/10-weeks-of-cloudops/Week8-Terraform-serverless-github-actions/Wild-Rydes/function.zip" #"path/to/your/lambda/function/code.zip"
  role             = aws_iam_role.lambda_iam_role.arn
  source_code_hash = filebase64("/home/savvytech/Documents/DevOps/10-weeks-of-cloudops/Week8-Terraform-serverless-github-actions/Wild-Rydes/function.zip")
  publish          = true

  environment {
    variables = {
      TABLE_NAME = "Wild-Rides-Table"  # Replace with your DynamoDB table name
    }
  }
}
