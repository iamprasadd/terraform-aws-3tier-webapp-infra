#public route table -> internet gateway
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = {
    Name = "${var.project}-public-rt"
  }
}
#public subnet route table associations
resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
  for_each = { for idx, id in var.public_subnet_ids : idx => id }
  domain   = "vpc"
  tags = {
    Name = "${var.project}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = { for idx, id in var.public_subnet_ids : idx => id }
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value
  tags = {
    Name = "${var.project}-nat-gw-${each.key}"

  }
  depends_on = [aws_route_table.public_rt]

}
resource "aws_route_table" "app_rt" {
  for_each = { for idx, id in var.app_subnet_ids : idx => id }
  vpc_id   = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id

  }
  tags = {
    Name = "${var.project}-app-rt-${each.key}"
  }
}
#app subnet route table associations
resource "aws_route_table_association" "app_rta" {
  for_each       = { for idx, id in var.app_subnet_ids : idx => id }
  subnet_id      = each.value
  route_table_id = aws_route_table.app_rt[each.key].id
}

resource "aws_route_table" "data_rt" {
  for_each = { for idx, id in var.data_subnet_ids : idx => id }
  vpc_id   = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
  tags = {
    Name = "${var.project}-data-rt-${each.key}"
  }
}

#data subnet route table associations   
resource "aws_route_table_association" "data_rta" {
  for_each       = { for idx, id in var.data_subnet_ids : idx => id }
  subnet_id      = each.value
  route_table_id = aws_route_table.data_rt[each.key].id
}