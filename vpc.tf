# VPC
resource "aws_vpc" "myVPC"{
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = "myVPC"
  }
}
# Public 
resource "aws_subnet" "my-public-sub-1"{
   vpc_id = aws_vpc.myVPC.id
   cidr_block = "10.0.1.0/24"
   map_public_ip_on_launch = "true"
   availability_zone = "${var.AWS_DEFAULT_REGION}a"
   tags = {
       Name = "my-public-sub-1"
   }
}
resource "aws_subnet" "my-public-sub-2"{
   vpc_id = aws_vpc.myVPC.id
   cidr_block = "10.0.2.0/24"
   map_public_ip_on_launch = "true"
   availability_zone = "${var.AWS_DEFAULT_REGION}b"
   tags = {
       Name = "my-public-sub-2"
   }
}
resource "aws_subnet" "my-private-sub-1"{
   vpc_id = aws_vpc.myVPC.id
   cidr_block = "10.0.4.0/24"
   map_public_ip_on_launch = "false"
   availability_zone = "${var.AWS_DEFAULT_REGION}a"
   tags = {
       Name = "my-private-sub-1"
   }
}
resource "aws_subnet" "my-private-sub-2"{
   vpc_id = aws_vpc.myVPC.id
   cidr_block = "10.0.5.0/24"
   map_public_ip_on_launch = "false"
   availability_zone = "${var.AWS_DEFAULT_REGION}b"
   tags = {
       Name = "my-private-sub-2"
   }
}
