output "nat_gateway_ids" {
  value = [for ng in aws_nat_gateway.nat : ng.id]
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}
output "app_route_table_ids" {
  value = [for art in aws_route_table.app_rt : art.id]
}
output "data_route_table_ids" {
  value = [for drt in aws_route_table.data_rt : drt.id]
}
output "nat_eip_ids" {
  value = [for eip in aws_eip.nat : eip.id]
}