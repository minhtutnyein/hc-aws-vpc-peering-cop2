# Create data block for bastion host
# data "aws_ami" "bastion" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["137112412989"] # Amazon
#}

# Create data block for k8s nodes
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # ubuntu-noble
}

data "http" "myip" {
  url = "https://checkip.amazonaws.com/"
}