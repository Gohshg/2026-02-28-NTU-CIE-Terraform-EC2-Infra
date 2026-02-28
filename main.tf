#This file would be used to contain all of the IaC to create your resources (Ec2 + Security group resources)

resource "aws_instance" "public" {
  ami                         = "ami-0ac0e4288aa341886" # find the AMI ID of Amazon Linux 2023  
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-07613369be510e0d0"  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  key_name                    = "Gina-terraform-ec2-key-pair" #Change to your keyname
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 
  tags = {
    Name = "Gina-terraform-ec2"    #Prefix your own name
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "Gina-terraform-ec2-sg" #Security group name
  description = "Allow SSH inbound"
  vpc_id      = "vpc-024ab25ff63a3d405"  #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

