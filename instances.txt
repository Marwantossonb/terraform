
##security group

resource "aws_security_group" "sc1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description      = var.ingress.description
    from_port        = var.ingress.from_port
    to_port          = var.ingress.to_port
    protocol         = var.ingress.protocol
    cidr_blocks      = [var.ingress.cidr_blocks]
  }

  ingress {
    description      = var.ingress1.description
    from_port        = var.ingress1.from_port
    to_port          = var.ingress1.to_port
    protocol         = var.ingress1.protocol
    cidr_blocks      = [var.ingress1.cidr_blocks]
  }


  egress {
    from_port        = var.egress.from_port
    to_port          = var.egress.to_port
    protocol         = var.egress.protocol
    cidr_blocks      = [var.egress.cidr_blocks]
  }
}



##ec2
resource "aws_instance" "serverpriv" {
  ami           = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub["sub2"].id
   security_groups = [
    aws_security_group.sc1.id,
  ]


  user_data = <<-EOF
  #!/bin/bash
sudo yum update
sudo yum upgrade -y
sudo yum install httpd -y
sudo systemctl restart  httpd
  EOF
  
  
  tags = {
    Name = "example-instance"
  }
}


##ec2
resource "aws_instance" "serverpub" {
  ami           = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub["sub1"].id
   security_groups = [
    aws_security_group.sc1.id,
  ]
 associate_public_ip_address = true
    
  tags = {
    Name = "example-instance"
  }
}
