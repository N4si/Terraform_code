# VPC Modules
#  1 public Subnet
#  4 Private subnets
#  1 route table
#  route table asoociation
# DHCP option set for domain name


resource "aws_vpc" "my_vpc" {
  cidr_block =  var.vpc_cidr 
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "my-vpc"
  }
}


resource "aws_subnet" "public_subnet" {
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_us_east_1a_public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "Public Subnet Route Table."
  }
}

resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_vpc_us_east_1a_public.id
}

resource "aws_subnet" "private-subnet1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "Private Subnet2"
  }
}

resource "aws_subnet" "private-subnet3" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet3"
    }
}

resource "aws_subnet" "private-subnet4" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Private Subnet3"
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}


resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.my_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}
