
resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.sub["sub1"].id]  


  tags = {
    Name = "NLB"
  }
}


resource "aws_lb_target_group" "nlb_target_group" {
  name     = "nlb-target-group"
  port     = var.ingress.from_port
  protocol = var.ingress.protocol
  vpc_id   = aws_vpc.vpc1.id

  health_check {
    port     = var.ingress.from_port
    protocol = var.ingress.protocol
  }
}



resource "aws_lb_target_group_attachment" "serverpub1_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = aws_instance.serverpub1.id
  port             = var.ingress.from_port
}

resource "aws_lb_target_group_attachment" "serverpub2_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = aws_instance.serverpub2.id
  port             = var.ingress.from_port
}


resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.ingress.from_port
  protocol          = var.ingress.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}


# Define ALB
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.sub["sub2"].id, aws_subnet.sub["sub4"].id]  
}


# Define Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = var.ingress.from_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc1.id
  target_type = "instance"
}



# Connect EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "serverpriv1_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.serverpriv1.id
  port             = var.ingress.from_port
}


# Connect EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "serverpriv2_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.serverpriv2.id
  port             = var.ingress.from_port
}


resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.ingress.from_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
