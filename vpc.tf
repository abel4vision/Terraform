resource "aws_vpc" "workshop_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "workshop_vpc"
  }
}



#Creating Public Subnet
resource "aws_subnet" "main-1" {
  vpc_id     = aws_vpc.workshop_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "workshop_public_subnet"
  }
}

#Creating private subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.workshop_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "workshop_private_subnet"
  }
}



#creating IGW
resource "aws_internet_gateway" "gw" {
  vpc_id =  aws_vpc.workshop_vpc.id

  tags = {
    Name = "IGW"
  }
}

#creating public route table
resource "aws_route_table" "workshop-public-rt" {
  vpc_id = aws_vpc.workshop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "public-rt"
  }
}

# route table association public subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main-1.id
  route_table_id = aws_route_table.workshop-public-rt.id
}

#creating private route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.workshop_vpc.id

  route = []

  tags = {
    Name = "private_rt"
  }
}

# route table association private subnet
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}