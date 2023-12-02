resource "aws_amplify_app" "my_amplify_app" {
  name     = "Wild-Rides-Amplify-App"
  repository = var.codecommit_repository_url   # Replace with your Git repository URL
  oauth_token = var.codecommit_git_credential # Replace with your GitHub OAuth token
  # access_token =  var.codecommit_iam_username
  # access_ = var.codecommit_iam_password 

  iam_service_role_arn = aws_iam_role.iam_role_amplify.arn

  build_spec = <<BUILD_SPEC
version: 1
frontend:
  phases:
    build:
      commands: []
  artifacts:
    baseDirectory: /
    files:
      - '**/*'
  cache:
    paths: []
BUILD_SPEC
}

resource "aws_amplify_branch" "main" {
  app_id = aws_amplify_app.my_amplify_app.id
  branch_name = "main"
#   domain = var.domain_name # Replace with your custom domain

#   subdomain_settings {
#     branch_name  = "master"
#     prefix       = "prefix"
#   }
# }

# resource "aws_amplify_domain" "custom_domain" {
#    domain_name = var.domain_name  # Replace with your custom domain
#    app_id      = aws_amplify_app.my_amplify_app.id
# }

# output "amplify_app_url" {
#   value = aws_amplify_domain.custom_domain.endpoint
 }

output "amplify_app_url" {
  value = aws_amplify_app.my_amplify_app.default_domain
}
