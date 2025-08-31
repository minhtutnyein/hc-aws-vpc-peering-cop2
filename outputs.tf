# # Frontend Outputs
output "frontend_vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.frontend[0].id : null
}

output "frontend_public_subnet_ids" {
  description = "Map of public subnet IDs"
  value = {
    for name, subnet in aws_subnet.frontend_public : name => subnet.id
  }
}

output "frontend_private_subnet_ids" {
  description = "Map of private subnet IDs"
  value = {
    for name, subnet in aws_subnet.frontend_private : name => subnet.id
  }
}

output "frontend_eip_public_ips" {
  value = {
    for name, eip in aws_eip.frontend_nat_gateway_eips :
    name => eip.public_ip
  }
}

output "frontend_igw" {
  value = {
    for name, igw in aws_internet_gateway.frontend_igw : name => igw.id
  }
}

output "frontend_natGateway" {
  value = {
    for name, natGateway in aws_nat_gateway.frontendnatGateway : name => natGateway.id
  }
}

output "frontend_publicRouteTable" {
  value = aws_route_table.frontend_public
}

output "frontend_privateRouteTable_1" {
  value = aws_route_table.frontend_private_1
}

output "frontend_privateRouteTable_2" {
  value = aws_route_table.frontend_private_2
}

output "frontend_privateRouteTable_3" {
  value = aws_route_table.frontend_private_3
}

output "frontend_pub1_sg" {
  value = aws_security_group.frontend_pub1_sg
}

output "frontend_pri1_sg" {
  value = aws_security_group.frontend_pri1_sg
}

output "frontend_pri2_sg" {
  value = aws_security_group.frontend_pri1_sg
}

output "frontend_bastion_host" {
  value = aws_instance.frontend_public_host
}

output "frontend_pri1_host" {
  value = aws_instance.frontend_pri1_host
}

output "frontend_pri2_host" {
  value = aws_instance.frontend_pri2_host
}

output "frontend_pri3_host" {
  value = aws_instance.frontend_pri3_host
}

output "frontend_private_key" {
  description = "Private key for SSH access"
  value       = tls_private_key.frontend_key.private_key_openssh
  sensitive   = true
}
# # Backend Outputs
output "backend_vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.backend[0].id : null
}

output "backend_public_subnet_ids" {
  description = "Map of public subnet IDs"
  value = {
    for name, subnet in aws_subnet.backend_public : name => subnet.id
  }
}

output "backend_private_subnet_ids" {
  description = "Map of private subnet IDs"
  value = {
    for name, subnet in aws_subnet.backend_private : name => subnet.id
  }
}

output "backend_eip_public_ips" {
  value = {
    for name, eip in aws_eip.backend_nat_gateway_eips :
    name => eip.public_ip
  }
}

output "backend_igw" {
  value = {
    for name, igw in aws_internet_gateway.backend_igw : name => igw.id
  }
}

output "backend_natGateway" {
  value = {
    for name, natGateway in aws_nat_gateway.backendnatGateway : name => natGateway.id
  }
}

output "backend_publicRouteTable" {
  value = aws_route_table.backend_public
}

output "backend_privateRouteTable_1" {
  value = aws_route_table.backend_private_1
}

output "backend_privateRouteTable_2" {
  value = aws_route_table.backend_private_2
}

output "backend_privateRouteTable_3" {
  value = aws_route_table.backend_private_3
}

output "backend_pub1_sg" {
  value = aws_security_group.backend_pub1_sg
}

output "backend_pri1_sg" {
  value = aws_security_group.backend_pri1_sg
}

output "backend_pri2_sg" {
  value = aws_security_group.backend_pri1_sg
}

output "backend_bastion_host" {
  value = aws_instance.backend_public_host
}

output "backend_pri1_host" {
  value = aws_instance.backend_pri1_host
}

output "backend_pri2_host" {
  value = aws_instance.backend_pri2_host
}

output "backend_pri3_host" {
  value = aws_instance.backend_pri3_host
}

output "backend_private_key" {
  description = "Private key for SSH access"
  value       = tls_private_key.backend_key.private_key_openssh
  sensitive   = true
}
# # VPC Peering Outputs
output "peering_connection_id" {
  description = "The of the VPC peering connection"
  value = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

output "peering_connection_status" {
  description = "The status of the VPC peering connection"
  value = aws_vpc_peering_connection.frontend_to_backend_peer.accept_status
}