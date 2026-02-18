# WHY: Create a role that allows EC2 instances to act on behalf of the engineers
resource "aws_iam_role" "ec2_codedeploy_role" {
  name = "static-ec2-role"

  # WHY: Allow the EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# WHY: Attach the official AWS policy that gives permissions for CodeDeploy and S3 (to download code)
resource "aws_iam_role_policy_attachment" "ec2_codedeploy_policy_attach" {
  role       = aws_iam_role.ec2_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# WHY: Create the "Instance Profile"
resource "aws_iam_instance_profile" "static_profile" {
  name = "static-ec2-profile"
  role = aws_iam_role.ec2_codedeploy_role.name
}