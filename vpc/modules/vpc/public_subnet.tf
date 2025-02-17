# ----------------------------------------------------------------------------------------------------------------
# Public Subnet and associated resources
# ----------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags, {
      Name = "${local.name_tag_prefix}-subnet-public${count.index}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag_prefix}-rt-public"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}


# ----------------------------------------------------------------------------------------------------------------
# NAT Gateway for the private subnet to go out of VPC to the internet gateway
# ----------------------------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "main" {
  count = length(var.azs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge(local.common_tags, {
    Name = "${local.name_tag_prefix}-nat${count.index}"
  })
}

# ----------------------------------------------------------------------------------------------------------------
# AWS Elastic fixed IP for NAT Gateway
# ----------------------------------------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count = length(var.azs)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_tag_prefix}-eip_nat${count.index}"
  })
}
