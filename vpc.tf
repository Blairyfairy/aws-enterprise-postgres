data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "enterprise" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${var.environment}-enterprise-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.enterprise.id
  tags   = { Name = "${var.environment}-igw" }
}

# 3 Availability Zones for maximum enterprise fault tolerance
resource "aws_subnet" "database" {
  count             = 3
  vpc_id            = aws_vpc.enterprise.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.environment}-db-subnet-${data.aws_availability_zones.available.names[count.index]}" }
}

resource "aws_db_subnet_group" "aurora" {
  name        = "${var.environment}-aurora-db-subnet-group"
  subnet_ids  = aws_subnet.database[*].id
  description = "Private database subnets across 3 AZs for Aurora HA"
}
