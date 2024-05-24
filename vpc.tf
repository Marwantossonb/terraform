
 ##vpc

resource "aws_vpc" "vpc1" {
  cidr_block       = var.cider-vpc[0]
  tags = {
    Name = "vpc1"
  }
}

##subent

resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.vpc1.id
  for_each=var.cider-sub
  cidr_block = each.value
  availability_zone = each.key == "sub1" || each.key == "sub2" ? var.availability_zones[0] : var.availability_zones[1]

  tags = {
    Name = "Main"
  }
}


##gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "main"
  }
}

##route table public

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc1.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt"
  }

}




resource "aws_eip" "one" {
  domain = "vpc"  
}


resource "aws_eip" "two" {
  domain = "vpc"  
}



## nat gateway 

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.sub["sub1"].id
  allocation_id = aws_eip.one.id
  depends_on=[
    aws_subnet.sub["sub1"]
  ] 
  tags = {
    Name = "gw NAT"
  }
}



##route table private

resource "aws_route_table" "rtp" {
  vpc_id = aws_vpc.vpc1.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "rtp"
  }

}

 

resource "aws_route_table_association" "rt-private1" {
  subnet_id      = aws_subnet.sub["sub2"].id
  route_table_id = aws_route_table.rtp.id
}

resource "aws_route_table_association" "rt-private2" {
  subnet_id      = aws_subnet.sub["sub4"].id
  route_table_id = aws_route_table.rtp.id
}


resource "aws_route_table_association" "rt-public1" {
  subnet_id      = aws_subnet.sub["sub1"].id
  route_table_id = aws_route_table.rt.id
}


resource "aws_route_table_association" "rt-public2" {
  subnet_id      = aws_subnet.sub["sub3"].id
  route_table_id = aws_route_table.rt.id
}
