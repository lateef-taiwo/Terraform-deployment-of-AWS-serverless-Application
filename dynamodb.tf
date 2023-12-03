resource "aws_dynamodb_table" "Wild-Rides-Details-db" {
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

output "aws_dynamodb_table_arn" {
    value = aws_dynamodb_table.Wild-Rides-Details-db.arn  
}