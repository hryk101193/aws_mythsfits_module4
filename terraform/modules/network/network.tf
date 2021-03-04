#vnet作成
resource "aws_vpc" "vpc" {
  cidr_block       	    = "10.0.0.0/16"
	enable_dns_support	    = true
	enable_dns_hostnames	= true

    tags = {
        name = "${var.prefix}-vpc"
    }
}

#subnet作成
resource "aws_subnet" "public_subnet_one" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.region}a"

    tags = {
      name = "${var.prefix}-public-one"
    }
}

resource "aws_subnet" "public_subnet_two" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}b"

    tags = {
      name = "${var.prefix}-public-two"
    }
}

resource "aws_subnet" "private_subnet_one" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}a"

    tags = {
      name = "${var.prefix}-private-one"
    }
}

resource "aws_subnet" "private_subnet_two" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "${var.region}b"

    tags = {
      name = "${var.prefix}-private-two"
    }
}

#internet gateway作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    name = "${var.prefix}-igw"
  }
}

#public route table作成
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "${var.prefix}-route-table-public"
  }
}

#public route table association
resource "aws_route_table_association" "public_rta_one" {
  subnet_id = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta_two" {
  subnet_id = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.public_rt.id
}

#public route 作成
resource "aws_route" "public_r" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#eip 作成
resource "aws_eip" "ngw_eip_one" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "ngw_eip_two" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

#nat gateway 作成
resource "aws_nat_gateway" "ngw_one" {
  allocation_id = aws_eip.ngw_eip_one.id
  subnet_id = aws_subnet.public_subnet_one.id
}

resource "aws_nat_gateway" "ngw_two" {
  allocation_id = aws_eip.ngw_eip_two.id
  subnet_id = aws_subnet.public_subnet_two.id
}

#private route table作成
resource "aws_route_table" "private_rt_one" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "${var.prefix}-private-route-table-one"
  }
}

resource "aws_route_table" "private_rt_two" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "${var.prefix}-private-route-table-two"
  }
}

#private route 作成
resource "aws_route" "private_r_one" {
  route_table_id = aws_route_table.private_rt_one.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw_one.id
}

resource "aws_route" "private_r_two" {
  route_table_id = aws_route_table.private_rt_two.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw_two.id
}

#private route table association
resource "aws_route_table_association" "private_rta_one" {
  subnet_id = aws_subnet.private_subnet_one.id
  route_table_id = aws_route_table.private_rt_one.id
}

resource "aws_route_table_association" "private_rta_two" {
  subnet_id = aws_subnet.private_subnet_two.id
  route_table_id = aws_route_table.private_rt_two.id
}

#vpc endpoint for dynamoDB
resource "aws_vpc_endpoint" "dynamoDB"{
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [
    aws_route_table.private_rt_one.id,
    aws_route_table.private_rt_two.id
  ]
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": {
        "Effect": "Allow",
        "Action": "*",
        "Principal": "*",
        "Resource": "*"
      }
    }
    POLICY
}

#security group
resource "aws_security_group" "ec2" {
  name = "ec2"
  description = "Access to the fargate containers from the Internet"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 0
    to_port = 0
    description = "Allow access to NLB from anywhere on the internet"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    protocol = "-1"
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow access to internet from fargate"
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
}