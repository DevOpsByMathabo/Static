# WHY: Create the blueprint for the servers
resource "aws_launch_template" "static_lt" {
  name_prefix   = "static-launch-template"
  image_id      = data.aws_ami.ubuntu.id 
  instance_type = var.instance_type

  # WHY: Attach the IAM Instance Profile so the server can talk to CodeDeploy
  iam_instance_profile {
    name = aws_iam_instance_profile.static_profile.name
  }

  # WHY: Attach the security group so only the Load Balancer can talk to it
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  # WHY: The startup script. Wait for system updates to finish, then install Nginx, then CodeDeploy.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              
              # WHY: Detailed logging to help you debug /var/log/cloud-init-output.log
              set -x 

              # Instead of sleeping for 30s, we wait until the lock is actually free.
              echo "Waiting for apt lock to release..."
              while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
                 echo "Apt is locked. Waiting..."
                 sleep 5
              done

              # --- PRIORITY 1: WEB SERVER ---
              echo "Installing Nginx..."
              apt-get update -y
              
              # WHY: Retry loop in case install fails for other reasons
              until apt-get install -y nginx; do
                echo "Nginx install failed. Retrying in 5 seconds..."
                sleep 5
              done
              
              systemctl start nginx
              systemctl enable nginx
              
              # Create the verification page
              echo "<h1>System Online</h1><p>Server ID: $(hostname)</p>" > /var/www/html/index.html

              # --- PRIORITY 2: CODE DEPLOY AGENT ---
              apt-get install -y ruby-full ruby-webrick wget
              
              cd /home/ubuntu
              wget https://aws-codedeploy-af-south-1.s3.af-south-1.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              service codedeploy-agent start
              EOF
  )

  # WHY: Add tags to track costs later
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "static-web-server"
    }
  }
}