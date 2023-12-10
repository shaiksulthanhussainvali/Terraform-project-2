# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2XJAUE43FI75EKVZ"
  secret_key = "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"
}

# VPC 
resource "aws_vpc" "ibm" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "IBM"
  }
}

# Public Subnet
resource "aws_subnet" "ibm_pub_sb" {
  vpc_id     = aws_vpc.ibm.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "IBM-PUB-SB"
  }
}

# Private Subnet
resource "aws_subnet" "ibm_pvt_sb" {
  vpc_id     = aws_vpc.ibm.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "IBM-PVT-SB"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ibm_igw" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-IGW"
  }
}

# Public Route Table
resource "aws_route_table" "ibm_pub_rt" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-PUB-RT"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.ibm_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ibm_igw.id
}


# Private Route Table
# Default is private 
resource "aws_route_table" "ibm_pvt_rt" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-PVT-RT"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "ibm_pub_assoc" {
  subnet_id      = aws_subnet.ibm_pub_sb.id
  route_table_id = aws_route_table.ibm_pub_rt.id
}

# Private Route Table Association
resource "aws_route_table_association" "ibm_pvt_assoc" {
  subnet_id      = aws_subnet.ibm_pvt_sb.id
  route_table_id = aws_route_table.ibm_pvt_rt.id
}
