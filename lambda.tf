resource "aws_lambda_function" "wild_rides_lambda" {
  function_name    = "wild-rides-lambda-function"
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  memory_size = var.lambda_memory_size
  timeout = var.lambda_timeout
  #filename         = "./function.zip" #"path/to/your/lambda/function/code.zip"
  role             = aws_iam_role.lambda_iam_role.arn
 # source_code_hash = filebase64("function.zip")
  #publish          = true
  depends_on = [aws_iam_role.lambda_iam_role]
  description = var.lambda_description
  environment {
    variables = {
      TABLE_NAME = "Wild-Rides-Table"  # Replace with your DynamoDB table name
    }
  }
}


resource "aws_lambda_function_event_invoke_config" "test_event_config" {
  function_name = aws_lambda_function.wild_rides_lambda.function_name

  destination_config {
    on_success {
      destination = aws_lambda_function.wild_rides_lambda.arn
    }

    on_failure {
      destination = aws_lambda_function.wild_rides_lambda.arn
    }
  }
}

resource "null_resource" "invoke_test_event" {
  provisioner "local-exec" {
    command = <<EOT
      aws lambda invoke \
        --function-name ${aws_lambda_function.wild_rides_lambda.function_name} \
        --payload '{"key1":"value1","key2":"value2"}' \
        /dev/null
    EOT
  }

  depends_on = [aws_lambda_function_event_invoke_config.test_event_config]
}
