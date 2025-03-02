# ✅ Security Group for EC2
resource "aws_security_group" "ec2_sg" {
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
    Name = "EC2_SG"
  }
}

# ✅ EC2 Instances
resource "aws_instance" "servers" {
  count         = 3
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = templatefile("${path.module}/userdata.sh", { server_name = "server${count.index + 1}" })

  tags = {
    Name = "Server${count.index + 1}"
  }
}
