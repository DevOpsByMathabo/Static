# WHY: Create the Application Load Balancer 
resource "aws_lb" "static_alb" {
  name               = "static-alb"
  internal           = false
  load_balancer_type = "application"
  
  # WHY: Attach the Security Group 
  security_groups    = [aws_security_group.alb_sg.id]
  
  # WHY: Connect to both subnets so the ALB works even if one zone fails
  subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "static-alb"
  }
}

# WHY: Create a "Target Group" (The Waiting Room). The Load Balancer sends traffic here.
resource "aws_lb_target_group" "static_tg" {
  name     = "static-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.static_vpc.id

  # WHY: Check if is alive. If the server is dead, the ALB stops sending traffic to it.
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# WHY: Create a Listener to guide traffic to the Target Group.
resource "aws_lb_listener" "static_listener" {
  load_balancer_arn = aws_lb.static_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.static_tg.arn
  }
}