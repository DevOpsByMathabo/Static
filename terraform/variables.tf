# --- Region & Availability Zones ---
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "af-south-1"
}

variable "az_1" {
  description = "Primary Availability Zone (Zone A)"
  type        = string
  default     = "af-south-1a"
}

variable "az_2" {
  description = "Secondary Availability Zone (Zone B)"
  type        = string
  default     = "af-south-1b"
}

# --- Network Configuration ---
variable "vpc_cidr" {
  description = "The IP range for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  description = "IP range for Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "IP range for Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

# --- Server Configuration ---
variable "instance_type" {
  description = "The type of EC2 instance to run (t3.micro)"
  type        = string
  default     = "t3.micro"
}

# --- Auto Scaling Group Configuration ---
variable "asg_min_size" {
  description = "Minimum number of servers to run"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of servers to run"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Ideal number of servers to run"
  type        = number
  default     = 2
}