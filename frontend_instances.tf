# #Create EC2 Instances for Bastion host
resource "aws_instance" "frontend_public_host" {
  ami             = data.aws_ami.public_instance.id
  subnet_id       = aws_subnet.frontend_public["frontend_publicSubnet_1"].id
  instance_type   = var.public_instance
  security_groups = [aws_security_group.frontend_pub1_sg.id]
  key_name        = aws_key_pair.frontend_key.id

  user_data = <<-EOF
              #!/bin/bash
              echo "Running initialization script"
              sudo su -
              yum update -y
              yum upgrade -y
              yum install -y net-tools
              curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.3/2024-12-12/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
              mkdir ~/.kube/
              hostnamecto set-hostname bastionHost01
              EOF

  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pub1_instance_name}" },
    var.common_tags
  )
}

# Create EC2 Instances for Private Instance 01
resource "aws_instance" "frontend_pri1_host" {
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = aws_subnet.frontend_private["frontend_privateSubnet_1"].id
  instance_type   = var.ec2_nodes
  security_groups = [aws_security_group.frontend_pri1_sg.id]
  key_name        = aws_key_pair.frontend_key.id

  #user_data = file("scripts/nonprod-k8s-masterNode01.sh")


  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri1_instance_name}" },
    var.common_tags
  )
}

# # Create EC2 instances for private instance 02
resource "aws_instance" "frontend_pri2_host" {
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = aws_subnet.frontend_private["frontend_privateSubnet_2"].id
  instance_type   = var.ec2_nodes
  security_groups = [aws_security_group.frontend_pri2_sg.id]
  key_name        = aws_key_pair.frontend_key.id

  #user_data = file("scripts/nonprod-k8s-workerNode01.sh")


  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri2_instance_name}" },
    var.common_tags
  )
}

# # Create EC2 instances for private instance 03
resource "aws_instance" "frontend_pri3_host" {
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = aws_subnet.frontend_private["frontend_privateSubnet_3"].id
  instance_type   = var.ec2_nodes
  security_groups = [aws_security_group.frontend_pri3_sg.id]
  key_name        = aws_key_pair.frontend_key.id

  #user_data = file("scripts/nonprod-k8s-workerNode02.sh")


  tags = merge(
    { Name = "${var.friendly_name_prefix}-${var.frontend_pri3_instance_name}" },
    var.common_tags
  )
}