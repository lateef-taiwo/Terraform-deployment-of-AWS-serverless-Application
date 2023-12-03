resource "aws_cognito_user_pool" "pool" {
  name = "myuserpool"
  mfa_configuration = "OFF"  # Use double quotes for string values
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  alias_attributes = ["phone_number", "email", "preferred_username"]
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"  # or "DEVELOPER"
    # Additional email configuration if needed
    # reply_to_email_address = "reply@example.com" (optional)
    # source_arn = aws_ses_email_identity.example.arn  # To be used if developer is choosed
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "YOUR VERIFICATION CODE"
    email_message        = "This is your confirmation code: {####}"
  }
  # other configuration options...
}

resource "aws_cognito_user_pool_client" "pool_client" {
  name                    = "my-client"
  user_pool_id            = aws_cognito_user_pool.pool.id
  # ... other configurations ...
}

output "userpool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.pool_client.id
}
