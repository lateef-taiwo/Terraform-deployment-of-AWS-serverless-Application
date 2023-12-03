resource "aws_dynamodb_table" "Student-Details-db" {
  name           = "Wild-Rides-Table"
  billing_mode   = "PAY_PER_REQUEST" 
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Name = "Production-DB"
  }
}
