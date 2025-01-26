# main.tf

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name = "vpc-${var.tags["Environment"]}"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidrs)
  cidr_block              = var.public_subnets_cidrs[count.index]
  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      Name = "public-subnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidrs)
  cidr_block        = var.private_subnets_cidrs[count.index]
  vpc_id            = aws_vpc.this.id
  availability_zone = var.azs[count.index]
  tags = merge(
    var.tags,
    {
      Name = "private-subnet-${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    {
      Name = "internet-gateway"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    {
      Name = "public-route-table"
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    var.tags,
    {
      Name = "nat-gateway"
    }
  )
}

resource "aws_eip" "this" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc   = true
  tags = merge(
    var.tags,
    {
      Name = "nat-gateway-eip"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    {
      Name = "private-route-table"
    }
  )
}

resource "aws_route" "private" {
  count                 = var.enable_nat_gateway ? 1 : 0
  route_table_id        = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
