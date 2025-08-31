# # Create EC2 Instance Keypair for Frontend
resource "tls_private_key" "frontend_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "frontend_key" {
  key_name   = local.frontend_private_key_filename
  public_key = tls_private_key.frontend_key.public_key_openssh
}

# # Create EC2 Instance Keypair for backend
resource "tls_private_key" "backend_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "backend_key" {
  key_name   = local.backend_private_key_filename
  public_key = tls_private_key.backend_key.public_key_openssh
}

locals {
  frontend_private_key_filename = "${var.friendly_name_prefix}-frontend-ssh-key.pem"
  backend_private_key_filename  = "${var.friendly_name_prefix}-backend-ssh-key.pem"
}
