# Create Security Group for frontend public-instance-01
resource "aws_security_group" "frontend_pub1_sg" {
  description = "Security group for bastion instances"
  name        = var.frontend_pub1_sg_name
  vpc_id      = aws_vpc.frontend[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pub1_sg_name}" },
    var.common_tags
  )
}

# Create Security Group for frontend private-instance-01
resource "aws_security_group" "frontend_pri1_sg" {
  description = "Security group for private-instance-01"
  name        = var.frontend_pri1_sg_name
  vpc_id      = aws_vpc.frontend[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri1_sg_name}" },
    var.common_tags
  )
}

# Create Security Group for frontend private-instance-02
resource "aws_security_group" "frontend_pri2_sg" {
  description = "Security group for private-instance-02"
  name        = var.frontend_pri2_sg_name
  vpc_id      = aws_vpc.frontend[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri2_sg_name}" },
    var.common_tags
  )
}

# Create Security Group for frontend private-instance-03
resource "aws_security_group" "frontend_pri3_sg" {
  description = "Security group for private-instance-03"
  name        = var.frontend_pri3_sg_name
  vpc_id      = aws_vpc.frontend[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri3_sg_name}" },
    var.common_tags
  )
}

# Additional rules to be added AFTER backend security groups are created
# These should go in a separate file or after backend security groups

# # Security Rules for Frontend_Pub1_SG
# Ingress rules for frontend_pub1_sg from Outsite (My IP)
resource "aws_security_group_rule" "frontend_pub1_ssh_from_outside_myIP" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.frontend_pub1_sg.id
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "aws_security_group_rule" "frontend_pub1_icmp_from_outside_myIP" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.frontend_pub1_sg.id
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
}
# Egress rules for frontend_pub1_sg to Outsite (ANY)
resource "aws_security_group_rule" "frontend_pub1_ANY_to_outside_ANY" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.frontend_pub1_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
# # Security Rules for frontend_pri1_SG
resource "aws_security_group_rule" "frontend_pub1_ssh_to_frontend_pri1" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri1_sg.id
  source_security_group_id = aws_security_group.frontend_pub1_sg.id
}

resource "aws_security_group_rule" "frontend_pub1_icmp_to_frontend_pri1" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri1_sg.id
  source_security_group_id = aws_security_group.frontend_pub1_sg.id
}

resource "aws_security_group_rule" "frontend_pri1_ANY_to_outside_ANY" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.frontend_pri1_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
# # Create Security Rules for Frontend_Pri2_SG 
# # # Create Ingress Security Rules 
resource "aws_security_group_rule" "frontend_pri1_to_ping_private_instance_02" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.frontend_pri1_sg.id
}
resource "aws_security_group_rule" "frontend_pri1_to_ssh_private_instance_02" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.frontend_pri1_sg.id
}

resource "aws_security_group_rule" "backend_pri2_ping_to_frontend_private_instance_02_ingress" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.backend_pri2_sg.id
}
resource "aws_security_group_rule" "backend_pri2_ssh_to_frontend_private_instance_02_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.backend_pri2_sg.id
}
# # # Create Egress Security Rules 
resource "aws_security_group_rule" "frontend_pri2_ping_to_backend_private_instance_02_egress" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.backend_pri2_sg.id
}
resource "aws_security_group_rule" "frontend_pri2_ssh_to_backend_private_instance_02_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri2_sg.id
  source_security_group_id = aws_security_group.backend_pri2_sg.id
}
# # Create Security Rules for Frontend_Pri3_SG
# # # Create Ingress Security Rules
resource "aws_security_group_rule" "frontend_pri1_to_ping_private_instance_03" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.frontend_pri1_sg.id
}
resource "aws_security_group_rule" "frontend_pri1_to_ssh_private_instance_03" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.frontend_pri1_sg.id
}

resource "aws_security_group_rule" "backend_pri3_ping_to_frontend_private_instance_03_ingress" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.backend_pri3_sg.id
}
resource "aws_security_group_rule" "backend_pri3_ssh_to_frontend_private_instance_03_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.backend_pri3_sg.id
}
# # # Create Egress Security Rules
resource "aws_security_group_rule" "frontend_pri3_ping_to_backend_private_instance_03_egress" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.backend_pri3_sg.id
}
resource "aws_security_group_rule" "frontend_pri3_ssh_to_backend_private_instance_03_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_pri3_sg.id
  source_security_group_id = aws_security_group.backend_pri3_sg.id
}