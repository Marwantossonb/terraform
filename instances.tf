resource "aws_security_group" "http" {
  name        = "http"
  description = "http"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "http"
  }
}



resource "aws_instance" "server" {
  ami           = "ami-0abb03f8142ebd755"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub1.id
   security_groups = [
    aws_security_group.http.id,
  ]
 associate_public_ip_address = true
 user_data = <<-EOF
      #!/bin/sh
      sudo yum update -y
      sudo yum install -y httpd
      sudo systemctl start httpd
      sudo systemctl enable httpd
      sudo touch /var/www/html/index.html
      sudo chmod 777 /var/www/html/index.html
      echo "<h1>Hello World from [ marwan ] apache $(hostname -f)</h1>" > /var/www/html/index.html
      sudo chmod 644 /var/www/html/index.html
      sudo systemctl restart httpd
      sudo systemctl enable --now httpd
      EOF

 
  tags = {
    Name = "ins"
  }
}

