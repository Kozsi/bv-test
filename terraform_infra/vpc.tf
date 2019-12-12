resource "aws_vpc" "wp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy     = "dedicated"
}

resource "aws_internet_gateway" "wp_gw" {
  vpc_id = aws_vpc.wp_vpc.id
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.wp_vpc.id

  cidr_block        = var.public_cidr
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.wp_vpc.id

  cidr_block        = var.public_cidr2
  availability_zone = "eu-west-1b"
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.wp_vpc.id

  cidr_block        = var.private_cidr
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.wp_vpc.id

  cidr_block        = var.private_cidr2
  availability_zone = "eu-west-1b"
}

