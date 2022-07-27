// AWS VPC 
resource "aws_vpc" "fgtvm-vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = "terraform demo"
  }
}

resource "aws_subnet" "publicsubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz1
  availability_zone = var.az1
  tags = {
    Name = "public subnet az1"
  }
}

resource "aws_subnet" "publicsubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz2
  availability_zone = var.az2
  tags = {
    Name = "public subnet az2"
  }
}


resource "aws_subnet" "privatesubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.privatecidraz1
  availability_zone = var.az1
  tags = {
    Name = "private subnet az1"
  }
}

resource "aws_subnet" "privatesubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.privatecidraz2
  availability_zone = var.az2
  tags = {
    Name = "private subnet az2"
  }
}

resource "aws_subnet" "hasyncmgmtsubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.hasyncmgmtcidraz1
  availability_zone = var.az1
  tags = {
    Name = "hasyncmgmt subnet az1"
  }
}

resource "aws_subnet" "hasyncmgmtsubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.hasyncmgmtcidraz2
  availability_zone = var.az2
  tags = {
    Name = "hasyncmgmt subnet az2"
  }
}

