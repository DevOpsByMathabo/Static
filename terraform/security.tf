# WHY: Create a Security Group for the Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "static-alb-sg"
  description = "Allow public internet traffic"
  vpc_id      = aws_vpc.static_vpc.id

  # WHY: Allow anyone on the internet to visit the website via HTTP
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WHY: Allow the Load Balancer to send traffic out to the servers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "static-alb-sg"
  }
}

# WHY: Create a Security Group for the Web Servers
resource "aws_security_group" "server_sg" {
  name        = "static-server-sg"
  description = "Allow traffic ONLY from the Load Balancer"
  vpc_id      = aws_vpc.static_vpc.id

  # WHY: Only allow traffic coming from the Load Balancer
  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] 
  }

  # WHY: Allow servers to download updates (like Nginx) from the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WHY: Allow SSH for debugging
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "static-server-sg"
  }
}