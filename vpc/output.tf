output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "public_route_table" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table" {
  value = aws_route_table.private_route_table.id
}

output "rdsprivate_route_table" {
  value = aws_route_table.rdsprivate_route_table.id
}