resource "aws_vpc_peering_connection" "frontend_to_backend_peer" {
  peer_vpc_id = aws_vpc.backend[0].id
  vpc_id      = aws_vpc.frontend[0].id
  auto_accept = true

  tags = merge(
    {
      Name = "${var.friendly_name_prefix}-frontend_to_backend"
    },
    var.common_tags
  )
}

# # # Add Routes Frontend to Backend
resource "aws_route" "frontend_private_2_to_backend_private_2" {
  route_table_id            = aws_route_table.frontend_private_2[0].id
  destination_cidr_block    = aws_subnet.backend_private["backend_privateSubnet_2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "frontend_private_2_to_backend_private_3" {
  route_table_id            = aws_route_table.frontend_private_2[0].id
  destination_cidr_block    = aws_subnet.backend_private["backend_privateSubnet_3"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "frontend_private_3_to_backend_private_2" {
  route_table_id            = aws_route_table.frontend_private_3[0].id
  destination_cidr_block    = aws_subnet.backend_private["backend_privateSubnet_2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "frontend_private_3_to_backend_private_3" {
  route_table_id            = aws_route_table.frontend_private_3[0].id
  destination_cidr_block    = aws_subnet.backend_private["backend_privateSubnet_3"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}
# # # Add Routes Backend to Frontend
resource "aws_route" "backend_private_2_to_frontend_private_2" {
  route_table_id            = aws_route_table.backend_private_2[0].id
  destination_cidr_block    = aws_subnet.frontend_private["frontend_privateSubnet_2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "backend_private_2_to_frontend_private_3" {
  route_table_id            = aws_route_table.backend_private_2[0].id
  destination_cidr_block    = aws_subnet.frontend_private["frontend_privateSubnet_3"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "backend_private_3_to_frontend_private_2" {
  route_table_id            = aws_route_table.backend_private_3[0].id
  destination_cidr_block    = aws_subnet.frontend_private["frontend_privateSubnet_2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}

resource "aws_route" "backend_private_3_to_frontend_private_3" {
  route_table_id            = aws_route_table.backend_private_3[0].id
  destination_cidr_block    = aws_subnet.frontend_private["frontend_privateSubnet_3"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.frontend_to_backend_peer.id
}