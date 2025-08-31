#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
  default     = "ace"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default = {
    environment = "nonproduction"
    region      = "Singapore"
  }
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "create_vpc" {
  type        = bool
  description = "Boolean to create a VPC."
  default     = false
}

variable "public_cidr" {
  type        = string
  description = "Any Network"
  default     = "0.0.0.0/0"
}

# variable "public_subnets" {
#   type = map(object({
#     cidr_block        = string
#     availability_zone = string
#   }))
#   description = "Map of subnet configuration"
#   default = {
#     "frontend_publicSubnet_1" = {
#       cidr_block        = "10.0.1.0/24"
#       availability_zone = "ap-southeast-1a"
#     },
#     "frontend_publicSubnet_2" = {
#       cidr_block        = "10.0.2.0/24"
#       availability_zone = "ap-southeast-1b"
#     },
#     "frontend_publicSubnet_3" = {
#       cidr_block        = "10.0.3.0/24"
#       availability_zone = "ap-southeast-1c"
#     },
#     "backend_publicSubnet_1" = {
#       cidr_block        = "192.168.1.0/24"
#       availability_zone = "ap-southeast-1a"
#     },
#     "backend_publicSubnet_2" = {
#       cidr_block        = "192.168.2.0/24"
#       availability_zone = "ap-southeast-1b"
#     },
#     "backend_publicSubnet_3" = {
#       cidr_block        = "192.168.3.0/24"
#       availability_zone = "ap-southeast-1c"
#     },
#   }
# }

# variable "private_subnets" {
#   type = map(object({
#     cidr_block        = string
#     availability_zone = string
#   }))
#   description = "Map of subnet configuration"
#   default = {
#     "frontend_privateSubnet_1" = {
#       cidr_block        = "10.0.253.0/24"
#       availability_zone = "ap-southeast-1a"
#     },
#     "frontend_privateSubnet_2" = {
#       cidr_block        = "10.0.254.0/24"
#       availability_zone = "ap-southeast-1b"
#     },
#     "frontend_privateSubnet_3" = {
#       cidr_block        = "10.0.255.0/24"
#       availability_zone = "ap-southeast-1c"
#     },
#     "backend_privateSubnet_1" = {
#       cidr_block        = "192.168.253.0/24"
#       availability_zone = "ap-southeast-1a"
#     },
#     "backend_privateSubnet_2" = {
#       cidr_block        = "192.168.254.0/24"
#       availability_zone = "ap-southeast-1b"
#     },
#     "backend_privateSubnet_3" = {
#       cidr_block        = "192.168.254.0/24"
#       availability_zone = "ap-southeast-1c"
#     }
#   }
# }

variable "gateway_id" {
  type        = string
  description = "for local"
  default     = "local"
}

variable "create_igw" {
  type        = bool
  description = "Boolean to create a IGW."
  default     = true
}

variable "create_nat_gateway" {
  type        = bool
  description = "Boolean to create NAT Gateway"
  default     = true
}

variable "public_instance" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t2.medium"
}

variable "ec2_nodes" {
  description = "Instance type for kubernetes master node"
  type        = string
  default     = "t3.medium"
}
#------------------------------------------------------------------------------
# Frontend_Networking
#------------------------------------------------------------------------------
variable "frontend_vpc_name" {
  type        = string
  description = "Name of VPC."
  default     = "frontend-vpc"
}

variable "frontend_vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
  default     = "10.0.0.0/16"
}

variable "frontend_public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of subnet configuration"
  default = {
    "frontend_publicSubnet_1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-southeast-1a"
    },
    "frontend_publicSubnet_2" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-southeast-1b"
    },
    "frontend_publicSubnet_3" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-southeast-1c"
    }
  }
}

variable "frontend_private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of subnet configuration"
  default = {
    "frontend_privateSubnet_1" = {
      cidr_block        = "10.0.253.0/24"
      availability_zone = "ap-southeast-1a"
    },
    "frontend_privateSubnet_2" = {
      cidr_block        = "10.0.254.0/24"
      availability_zone = "ap-southeast-1b"
    },
    "frontend_privateSubnet_3" = {
      cidr_block        = "10.0.255.0/24"
      availability_zone = "ap-southeast-1c"
    }
  }
}

variable "frontend_igw_name" {
  type        = string
  description = "Name of VPC."
  default     = "frontend-igw"
}

variable "frontend_eip_config" {
  type = map(object({
    domain           = string
    public_ipv4_pool = string
  }))
  description = "Configuratin for Elastic IPs used by NAT Gateway"
  default = {
    "frontend_natGatewayEIP1" = {
      domain           = "vpc"
      public_ipv4_pool = "amazon"
    }
  }
}

variable "frontend_nat_gateway_config" {
  type = object({
    name              = string
    subnet_key        = string
    eip_allocation_id = string
  })
  description = "Map of subnet IDs where NAT Gateway will be placed"
  default = {
    name              = "frontend-natGateway"
    subnet_key        = "frontend_publicSubnet_1"
    eip_allocation_id = "frontend_natGatewayEIP1"
  }
}
#------------------------------------------------------------------------------
# Frontend AWS Key Pair
#------------------------------------------------------------------------------
variable "frontend_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "frontend-key01"
}
# #------------------------------------------------------------------------------
# # Frontend AWS Security Group
# #------------------------------------------------------------------------------
variable "frontend_pub1_sg_name" { #for bastion instances
  description = "Name of the Bastion Security Group"
  type        = string
  default     = "frontend-pub-sgp-01"
}

variable "frontend_pri1_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "frontend-pri-sgp-01"
}

variable "frontend_pri2_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "frontend-pri-sgp-02"
}

variable "frontend_pri3_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "frontend-pri-sgp-03"
}

variable "frontend_pub1_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "frontend-public-instance01"
}

variable "frontend_pri1_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "frontend-private-instance01"
}

variable "frontend_pri2_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "frontend-private-instance02"
}

variable "frontend_pri3_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "frontend-private-instance03"
}
#------------------------------------------------------------------------------
# Backend_Networking
#------------------------------------------------------------------------------
variable "backend_vpc_name" {
  type        = string
  description = "Name of VPC."
  default     = "backend-vpc"
}

variable "backend_vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
  default     = "192.168.0.0/16"
}

variable "backend_public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of subnet configuration"
  default = {
    "backend_publicSubnet_1" = {
      cidr_block        = "192.168.1.0/24"
      availability_zone = "ap-southeast-1a"
    },
    "backend_publicSubnet_2" = {
      cidr_block        = "192.168.2.0/24"
      availability_zone = "ap-southeast-1b"
    },
    "backend_publicSubnet_3" = {
      cidr_block        = "192.168.3.0/24"
      availability_zone = "ap-southeast-1c"
    }
  }
}

variable "backend_private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of subnet configuration"
  default = {
    "backend_privateSubnet_1" = {
      cidr_block        = "192.168.253.0/24"
      availability_zone = "ap-southeast-1a"
    },
    "backend_privateSubnet_2" = {
      cidr_block        = "192.168.254.0/24"
      availability_zone = "ap-southeast-1b"
    },
    "backend_privateSubnet_3" = {
      cidr_block        = "192.168.255.0/24"
      availability_zone = "ap-southeast-1c"
    }
  }
}

variable "backend_igw_name" {
  type        = string
  description = "Name of VPC."
  default     = "backend-igw"
}

variable "backend_eip_config" {
  type = map(object({
    domain           = string
    public_ipv4_pool = string
  }))
  description = "Configuratin for Elastic IPs used by NAT Gateway"
  default = {
    "backend_natGatewayEIP1" = {
      domain           = "vpc"
      public_ipv4_pool = "amazon"
    }
  }
}

variable "backend_nat_gateway_config" {
  type = object({
    name              = string
    subnet_key        = string
    eip_allocation_id = string
  })
  description = "Map of subnet IDs where NAT Gateway will be placed"
  default = {
    name              = "backend-natGateway"
    subnet_key        = "backend_publicSubnet_1"
    eip_allocation_id = "backend_natGatewayEIP1"
  }
}
#------------------------------------------------------------------------------
# Backend AWS Key Pair
#------------------------------------------------------------------------------
variable "backend_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "backend-key01"
}
# #------------------------------------------------------------------------------
# # Backend AWS Security Group
# #------------------------------------------------------------------------------
variable "backend_pub1_sg_name" { #for bastion instances
  description = "Name of the Bastion Security Group"
  type        = string
  default     = "backend-pub-sgp-01"
}

variable "backend_pri1_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "backend-pri-sgp-01"
}

variable "backend_pri2_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "backend-pri-sgp-02"
}

variable "backend_pri3_sg_name" { #for k8s master node
  description = "Name of the k8s-masternode security group"
  type        = string
  default     = "backend-pri-sgp-03"
}

variable "backend_pub1_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "backend-public-instance01"
}

variable "backend_pri1_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "backend-private-instance01"
}

variable "backend_pri2_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "backend-private-instance02"
}

variable "backend_pri3_instance_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "backend-private-instance03"
}