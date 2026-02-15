# WHY: Create the VPC 
resource "aws_vpc" "static_vpc" {
  cidr_block = "10.0.0.0/16" 
  
  tags = {
    Name = "static-vpc"
  }
}

# WHY: Create an Internet Gateway 
resource "aws_internet_gateway" "static_igw" {
  vpc_id = aws_vpc.static_vpc.id

  tags = {
    Name = "static-igw"
  }
}

# WHY: Create a Public Route Table 
resource "aws_route_table" "static_public_rt" {
  vpc_id = aws_vpc.static_vpc.id

  tags = {
    Name = "static-public-rt"
  }
}

# WHY: Create Public Subnet 1 (Zone A - For High Availability)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.static_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "af-south-1a" 
  map_public_ip_on_launch = true 

  tags = {
    Name = "static-subnet-1"
  }
}

# WHY: Create Public Subnet 2 (Zone B - The backup zone)
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.static_vpc.id
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "af-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "static-subnet-2"
  }
}

# WHY: Connect Subnet 1 with the Route Table
resource "aws_route_table_connection" "public_connect_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.static_public_rt.id
}

# WHY: Connect Subnet 2 with the Route Table
resource "aws_route_table_connection" "public_connect_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.static_public_rt.id
}