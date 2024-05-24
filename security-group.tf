
## define instance security group

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




# Define ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id = aws_vpc.vpc1.id
  # Define ingress rules as needed
  ingress {
    from_port   = var.ingress.from_port
    to_port     = var.ingress.to_port
    protocol    = var.ingress.protocol
    cidr_blocks = [var.ingress.cidr_blocks]
  }
  
  egress {
    from_port        = var.egress.from_port
    to_port          = var.egress.to_port
    protocol         = var.egress.protocol
    cidr_blocks      = [var.egress.cidr_blocks]
  }
}
  
