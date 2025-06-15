// Data blocks for AMI 

data "aws_ami" "latest_amazon_linux" {
  most_recent = true // fetch latet AMI 
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

// Data block for default VPC 

data "aws_vpc" "default_vpc" { 
  default = true //fetching default VPC 
}

// Data block for fetchin all subnet IDs

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id" // filters based on the default VPC ID 
    values = [data.aws_vpc.default_vpc.id]
  }
}


data "aws_subnet" "subnet_id" {
  id = data.aws_subnets.default_subnets.ids[0]  // using one from default subnets
}

resource "aws_security_group" "sg" {
  name        = "ec2_instance-sg"
  description = "security group for ec2_instance "
  vpc_id      = data.aws_vpc.default_vpc.id

// inbound for 22 for my custom public IP 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["38.224.232.41/32"]  //my public IP
  }


  # outbound all ports open
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // all ports 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_instance-SG"
  }
}


resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.aws_subnet.subnet_id.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "Terraform-t2micro"
  }
}
