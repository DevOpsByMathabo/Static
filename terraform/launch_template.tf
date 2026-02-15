# WHY: Create the blueprint for the servers
resource "aws_launch_template" "static_lt" {
  name_prefix   = "static-launch-template"
  image_id      = "ami-0002a762b9a78536f" 
  instance_type = var.instance_type

  # WHY: Attach the security group so only the Load Balancer can talk to it
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  # WHY: The startup script. This runs automatically when the server turns on.
  # It installs Nginx and creates the "System Online" HTML page.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>System Online</h1><p>Server ID: $(hostname)</p>" > /var/www/html/index.html
              EOF
  )

  # WHY: Add tags so we can track costs later
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "static-web-server"
    }
  }
}