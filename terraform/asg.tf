# WHY: Create the Auto Scaling Group
resource "aws_autoscaling_group" "static_asg" {
  name = "static-asg"
  
  # WHY: Tell the Auto Scaling Group which subnets to build servers in
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  
  # WHY: Use the Launch Template
  launch_template {
    id      = aws_launch_template.static_lt.id
    version = "$Latest"
  }

  # WHY: Use variables so capacity for Dev vs Prod is easily changed
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  # WHY: Connect these servers to the Load Balancer's Target Group
  target_group_arns = [aws_lb_target_group.static_tg.arn]

  # WHY: Use the "EC2" check so the servers stay alive even if Nginx fails. 
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "static-instance"
    propagate_at_launch = true
  }
}