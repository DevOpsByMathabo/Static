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

  # WHY: The startup script. Installs CodeDeploy Agent AND Nginx.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              
            # --- Install CodeDeploy Agent Dependencies ---
              # WHY: Update package list to get the latest versions
              apt-get update -y

              # WHY: Install Ruby (required for CodeDeploy Agent) and wget (to download files)
              apt-get install -y ruby-full wget
              
            # --- Install CodeDeploy Agent ---
              cd /home/ubuntu

              # WHY: Download the agent specifically for the Cape Town region (af-south-1)
              wget https://aws-codedeploy-af-south-1.s3.af-south-1.amazonaws.com/latest/install
              
              # WHY: Make the installer executable
              chmod +x ./install
              
              # WHY: Run the install command
              ./install auto
              
              # WHY: Ensure the agent service is started
              service codedeploy-agent start

            # --- Install Web Server (Your Original Logic) ---
              # WHY: Install the Nginx web server
              apt-get install -y nginx
              
              # WHY: Start Nginx immediately
              systemctl start nginx
              
              # WHY: Ensure Nginx starts if the server reboots
              systemctl enable nginx
              
              # WHY: Create the default HTML page with the Hostname for verification
              echo "<h1>System Online</h1><p>Server ID: $(hostname)</p>" > /var/www/html/index.html
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