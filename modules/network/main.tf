resource "aws_vpc" "my_vpcep" {
  cidr_block = "15.0.0.0/16"
}

resource "aws_subnet" "public_subnet_vpcep" {
  vpc_id                  = aws_vpc.my_vpcep.id
  cidr_block              = "15.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_vpcep" {
  vpc_id            = aws_vpc.my_vpcep.id
  cidr_block        = "15.0.2.0/24"
  availability_zone = "us-east-1b"
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpcep.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpcep.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpcep.id
  
}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_vpcep.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet_vpcep.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.my_vpcep.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpcep.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["15.0.1.0/24"]
  }
  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpcep.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami                         = "ami-0440d3b780d96b29d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_vpcep.id
  associate_public_ip_address = true
  key_name                    = "my_key_pair2"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_vpcep.id
  key_name               = "my_key_pair2"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}

