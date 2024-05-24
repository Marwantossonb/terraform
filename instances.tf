
##ec2-public1
resource "aws_instance" "serverpub1" {
  ami           = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub["sub1"].id
  associate_public_ip_address = true
   security_groups = [
    aws_security_group.sc1.id,
  ]
  key_name = "key"
  
  provisioner "remote-exec" {
    inline = [ 
"sudo yum update -y",
"sudo yum install -y httpd",
"sudo dnf install -y mod_proxy_html",
"sudo sh -c 'echo \"ProxyPass \"/\" \"http://10.0.3.193:80/\"\" >> /etc/httpd/conf/httpd.conf'",
"sudo systemctl enable --now httpd",
"cd .ssh",
"echo '${file("${path.module}/id_rsa")}' > key.pem",
"chmod 400 \"key.pem\"",
"ssh -i \"key.pem\" ec2-user@10.0.3.193:80",
"sudo yum update -y",
"sudo yum install -y httpd",
"sudo touch /var/www/html/index.html",
"sudo chmod 777 /var/www/html/index.html",
"echo \"<h1>Hello World from [ marwan ] apache $(hostname -f)</h1>\" > /var/www/html/index.html",
"sudo chmod 644 /var/www/html/index.html",
"sudo systemctl enable --now httpd",
    ] 
    }


  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user" 
    private_key = file("/home/marwan/.ssh/id_rsa")
    timeout = "4m"
  }

  depends_on = [
    aws_lb.alb
  ]
 #associate_public_ip_address = true
    
  tags = {
    Name = "public1-instance"
  }
}


##ec2-public2
resource "aws_instance" "serverpub2" {
  ami           = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub["sub3"].id
  key_name = "key"
  #associate_public_ip_address = true
   security_groups = [
    aws_security_group.sc1.id,
  ]
  
   provisioner "remote-exec" {
    inline = [
"sudo yum update -y",
"sudo yum install -y httpd",
"sudo dnf install -y mod_proxy_html",
"sudo sh -c 'echo \"ProxyPass \"/\" \"http://10.0.1.56:80/\"\" >> /etc/httpd/conf/httpd.conf'",
"sudo systemctl enable --now httpd",
"cd .ssh",
"echo '${file("${path.module}/id_rsa")}' > key.pem",
"chmod 400 \"key.pem\"",
"ssh -i \"key.pem\" ec2-user@10.0.1.56:80",
"sudo yum update -y",
"sudo yum install -y httpd",
"sudo touch /var/www/html/index.html",
"sudo chmod 777 /var/www/html/index.html",
"echo \"<h1>Hello World from [ marwan ] apache $(hostname -f)</h1>\" > /var/www/html/index.html",
"sudo chmod 644 /var/www/html/index.html",
"sudo systemctl enable --now httpd",
    ] 
    }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user" 
    private_key = file("/home/marwan/.ssh/id_rsa")
    timeout = "4m"
  }
  depends_on = [
    aws_lb.alb
  ]
 associate_public_ip_address = true
    
  tags = {
    Name = "public2-instance"
  }
}




##ec2-private1
resource "aws_instance" "serverpriv1" {
  ami           = "ami-03c3351e3ce9d04eb"
  key_name = "key"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.sub["sub2"].id
   security_groups = [
    aws_security_group.sc1.id,
  ]
  tags = {
    Name = "example-instance"
  }
}



##ec2-private2
resource "aws_instance" "serverpriv2" {
  ami           = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  key_name = "key"
  subnet_id     = aws_subnet.sub["sub4"].id
   security_groups = [
    aws_security_group.sc1.id,
  ]

  tags = {
    Name = "example-instance"
  }
}

