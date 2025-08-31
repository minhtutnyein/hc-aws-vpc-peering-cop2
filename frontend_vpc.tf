# Create custom VPC
resource "aws_vpc" "frontend" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.frontend_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_vpc_name}" },
    var.common_tags
  )
}

# Create AWS internet gateway
resource "aws_internet_gateway" "frontend_igw" {
  count  = var.create_vpc && var.create_igw ? 1 : 0 # Conditional createion
  vpc_id = aws_vpc.frontend[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_igw_name}" },
    var.common_tags
  )
}

# Create public subnets
resource "aws_subnet" "frontend_public" {
  for_each                = var.frontend_public_subnets
  vpc_id                  = aws_vpc.frontend[0].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${each.key}" },
    var.common_tags
  )
}

# Create private subnets
resource "aws_subnet" "frontend_private" {
  for_each                = var.frontend_private_subnets
  vpc_id                  = aws_vpc.frontend[0].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${each.key}" },
    var.common_tags
  )
}

# Create EIP for NAT Gateway
resource "aws_eip" "frontend_nat_gateway_eips" {
  for_each         = var.frontend_eip_config
  domain           = each.value.domain
  public_ipv4_pool = each.value.public_ipv4_pool
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${each.key}" },
    var.common_tags
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "frontendnatGateway" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.frontend_nat_gateway_eips[var.frontend_nat_gateway_config.eip_allocation_id].id
  subnet_id     = aws_subnet.frontend_public[var.frontend_nat_gateway_config.subnet_key].id
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_nat_gateway_config.name}" },
    var.common_tags
  )
}


# Create routetable for public
resource "aws_route_table" "frontend_public" {
  vpc_id = aws_vpc.frontend[0].id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.frontend_igw[0].id
  }
  route {
    cidr_block = var.frontend_vpc_cidr
    gateway_id = var.gateway_id
  }
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_vpc_name}-public-rtb" },
    var.common_tags
  )
}

# Associate public subnets to public route table
resource "aws_route_table_association" "frontend_publicAssociation" {
  for_each = var.create_vpc ? var.frontend_public_subnets : {}

  subnet_id      = aws_subnet.frontend_public[each.key].id
  route_table_id = aws_route_table.frontend_public.id
}

# Create routetable for privateSubnet_1
resource "aws_route_table" "frontend_private_1" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.frontend[0].id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_nat_gateway.frontendnatGateway[0].id
  }
  route {
    cidr_block = var.frontend_vpc_cidr
    gateway_id = var.gateway_id
  }
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_vpc_name}-private-rtb-01" },
    var.common_tags
  )
}

# Associate  privateSubnet_1 to private route table_1
resource "aws_route_table_association" "frontend_privateAssociation_1" {
  for_each = var.create_vpc ? var.frontend_private_subnets : {}

  subnet_id      = aws_subnet.frontend_private["frontend_privateSubnet_1"].id
  route_table_id = aws_route_table.frontend_private_1[0].id
}

# Create routetable for privateSubnet_2
resource "aws_route_table" "frontend_private_2" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.frontend[0].id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_nat_gateway.frontendnatGateway[0].id
  }
  route {
    cidr_block = var.frontend_vpc_cidr
    gateway_id = var.gateway_id
  }
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_vpc_name}-private-rtb-02" },
    var.common_tags
  )
}

# Associate  privateSubnet_2 to private route table_2
resource "aws_route_table_association" "frontend_privateAssociation_2" {
  for_each = var.create_vpc ? var.frontend_private_subnets : {}

  subnet_id      = aws_subnet.frontend_private["frontend_privateSubnet_2"].id
  route_table_id = aws_route_table.frontend_private_2[0].id
}

# Create routetable for privateSubnet_3
resource "aws_route_table" "frontend_private_3" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.frontend[0].id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_nat_gateway.frontendnatGateway[0].id
  }
  route {
    cidr_block = var.frontend_vpc_cidr
    gateway_id = var.gateway_id
  }
  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_vpc_name}-private-rtb-03" },
    var.common_tags
  )
}

# Associate  privateSubnet_3 to private route table_3
resource "aws_route_table_association" "frontend_privateAssociation_3" {
  for_each = var.create_vpc ? var.frontend_private_subnets : {}

  subnet_id      = aws_subnet.frontend_private["frontend_privateSubnet_3"].id
  route_table_id = aws_route_table.frontend_private_3[0].id
}