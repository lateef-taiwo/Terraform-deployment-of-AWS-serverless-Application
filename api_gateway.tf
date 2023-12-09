# # Create API Gateway REST API
# resource "aws_api_gateway_rest_api" "serverless_api" {
#   name        = "ServerlessRESTAPI"
#   description = "Terraform Serverless REST API for Wild Rydes web application"

#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = aws_api_gateway_rest_api.serverless_api.id
#   parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
#   path_part = "wild-rides"
  
  
#   depends_on = [ aws_api_gateway_rest_api.serverless_api ]
  
#   }

# resource "aws_api_gateway_method" "example-method" {
#   rest_api_id = aws_api_gateway_rest_api.serverless_api.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = "OPTIONS"
#   authorization = "NONE" 
  
#   depends_on = [ aws_api_gateway_resource.resource ]
# }

# resource "aws_api_gateway_method_response" "example-method-response" {
#   rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = aws_api_gateway_method.example-method.http_method
#   status_code = 200

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = true,
#   }

#   response_models = {
#     "application/json" = "Empty"
#   }

#   depends_on = [aws_api_gateway_method.method]
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "POST"
#   authorization = "COGNITO_USER_POOLS"
#   authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

#   # request_parameters = {
#   #    "method.request.header.Authorization" = true
#   #    "gatewayresponse.header.Access-Control_Allow-Origin" = true
#   # }


# #  response_parameters = {
# #       "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
# #     }
#   # Integration with Lambda proxy
#   depends_on = [aws_api_gateway_resource.resource]
# }

# # Create Cognito User Pools authorizer
# resource "aws_api_gateway_authorizer" "cognito_authorizer" {
#   name                   = "CognitoAuthorizer"
#   rest_api_id            = aws_api_gateway_rest_api.serverless_api.id
#   type                   = "COGNITO_USER_POOLS"
#   identity_source        = "method.request.header.Authorization"
#   provider_arns          = [aws_cognito_user_pool.pool.arn]
#   authorizer_credentials = aws_iam_role.api_gateway_execution_role.arn
# }

# # Integration with Lambda proxy
# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.wild_rides_lambda.invoke_arn
# }
# # Create a deployment for the API Gateway
# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on = [aws_api_gateway_integration.integration]
#   rest_api_id = aws_api_gateway_rest_api.serverless_api.id
#   stage_name  = "prod"
# }


# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "serverless_api" {
  name        = "ServerlessRESTAPI"
  description = "Terraform Serverless REST API for Wild Rydes web application"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Enable CORS for the API
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  path_part   = "ride"
}

# Create Cognito User Pools authorizer
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                   = "CognitoAuthorizer"
  rest_api_id            = aws_api_gateway_rest_api.serverless_api.id
  type                   = "COGNITO_USER_POOLS"
  identity_source        = "method.request.header.Authorization"
  provider_arns          = [aws_cognito_user_pool.pool.arn]
  authorizer_credentials = aws_iam_role.api_gateway_execution_role.arn

}

# Create Method and Method Response for OPTIONS
resource "aws_api_gateway_method" "options_method" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}


# Create Lambda Integration
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.options_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.wild_rides_lambda.invoke_arn
}


resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Create a deployment for the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name  = "prod"
}
