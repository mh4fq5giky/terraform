output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = { for k, v in aws_subnet.public_subnets : k => v.id }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private_subnets : k => v.id }
}

output "rdsprivate_subnets" {
  value = { for k, v in aws_subnet.rdsprivate_subnets : k => v.id }
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