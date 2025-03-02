provider "aws" {
  region = var.aws_region
}

# ✅ Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

# ✅ Create Public Subnets
resource "aws_subnet" "public" {
  count             = 3
  vpc_id           = aws_vpc.main.id
  cidr_block       = "10.0.${count.index}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}

# ✅ Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainIGW"
  }
}

# ✅ Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB_SG"
  }
}
