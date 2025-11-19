output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}
output "app_subnet_ids" {
  value = [for s in aws_subnet.app : s.id]
}
output "data_subnet_ids" {
  value = [for s in aws_subnet.data : s.id]
}
output "public_subnet_azs" {
  value = [for s in aws_subnet.public : s.availability_zone]
}