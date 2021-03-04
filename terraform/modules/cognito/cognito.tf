resource "aws_cognito_user_pool" "user_pool" {
  name = "MysfitsUserPool"
  auto_verified_attributes = [ "email" ]
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "MysfitsUserPoolClient"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}