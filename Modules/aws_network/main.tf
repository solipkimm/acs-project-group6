# Terraform Config file (main.tf). This has provider block (AWS) and config for provisioning one EC2 instance resource.  

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
#   profile = "default"
  region = "us-east-1"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}





# Create VPC
resource "aws_vpc" "main" {

  cidr_block = "10.1.0.0/16"

   tags = merge(
    local.default_tags, {
      Name = "${var.env}-VPC"
    }
  )
}


# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  vpc_id     = aws_vpc.main.id

  tags = merge(
    local.default_tags, {
      Name = "${var.env}-private-subnet-${count.index + 1}"
    }
  )
}



# Create public subnets
resource "aws_subnet" "public" {
  count = length(var.public_cidr_blocks)

  cidr_block = var.public_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  vpc_id     = aws_vpc.main.id

 tags = merge(
    local.default_tags, {
      Name = "${var.env}-public-subnet-${count.index + 1}"
    }
  )
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  

  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${var.env}-igw"
    }
  )
}




# Create public route table and association
resource "aws_route_table" "public" {
  
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-route-table"
  }
}


resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}



# Create private route table and association
resource "aws_route_table" "private" {
  

  vpc_id = aws_vpc.main.id
  
  

  tags = {
    Name = "${var.env}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id

}