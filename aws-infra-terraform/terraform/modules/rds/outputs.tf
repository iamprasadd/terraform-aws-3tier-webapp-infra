output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}
output "db_address" {
  value = aws_db_instance.this.address
}
output "db_port" {
  value = aws_db_instance.this.port
}
output "db_identifier" {
  value = aws_db_instance.this.identifier
}
output "db_username" {
  value = var.db_username
}

output "db_name" {
  value = var.db_name
}