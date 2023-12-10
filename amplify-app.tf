resource "aws_amplify_app" "my_amplify_app" {
  name     = "Wild-Rides-Amplify-App"
  repository = var.codecommit_repository_url   # codecommit_repository_url
  oauth_token = var.codecommit_git_credential # codecommit_git_credential

  # Setup redirect from https://example.com to https://www.example.com
  # custom_rule {
  #   source = "https://example.com"
  #   status = "302"
  #   target = "https://www.example.com"
  #   }

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
  branch_name = var.app_branch
  
}

#Associated your domain to your amplify app
resource "aws_amplify_domain_association" "custom_domain" {
  app_id      = aws_amplify_app.my_amplify_app.id
  domain_name = var.domain_name
  wait_for_verification = true

   # https://example.com
   sub_domain {
     branch_name = var.app_branch
     prefix = ""
   }

    # https://www.example.com
  sub_domain {
    branch_name = var.app_branch
    prefix      = "www"
  }
}

output "amplify_app_domain_url" {
  value = aws_amplify_domain_association.custom_domain
 }

output "amplify_app_url" {
  value = aws_amplify_app.my_amplify_app.default_domain
}
