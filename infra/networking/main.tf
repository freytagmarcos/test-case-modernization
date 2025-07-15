# ----vpc/main.tf -----

data "aws_availability_zones" "available" {
  exclude_names = ["us-east-1e"]
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "vpc" {
   cidr_block = var.vpc_cidr
   enable_dns_hostnames = true
   enable_dns_support = true

   tags = {
      Name = "aws_vpc"
   }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "public_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  depends_on = [ aws_internet_gateway.igw ]
}
resource "aws_nat_gateway" "natgw" {
  subnet_id = aws_subnet.private_subnet[1].id
  allocation_id = aws_eip.eip.id
  connectivity_type = "public"
  tags = {
    name = "natgw"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private_rt"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.natgw.id  
}
resource "aws_route_table_association" "rt_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_private_association" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_security_group" "security_group" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
