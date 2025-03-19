resource "aws_subnet" "publics" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = false
  // map_public_ip_on_launch = var.public_subnets[count.index].map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name                                           = var.public_subnets[count.index].name
      "kubernetes.io/role/elb"                       = 1
      "kubernetes.io/cluster/${var.tags["Project"]}" = "shared"
    }
  )
}
