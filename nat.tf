# Nat Getway and Associated Resources

resource "aws_eip" "my-nat-eip" {
  vpc = true
}
resource "aws_nat_gateway" "my-nat-gw" {
  allocation_id = aws_eip.my-nat-eip.id
  subnet_id = aws_subnet.my-public-sub-1.id
}
resource "aws_internet_gateway" "my-ig" {
 vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "test_gateway"
  }
} 
 
#VPC Setup for NAT
resource "aws_route_table" "my-public-rt" {
    vpc_id = aws_vpc.myVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my-nat-gw.id
    }
    tags = {
        Name = "my-public-rt"
    }
}
# Route Associations Private
resource "aws_route_table_association" "my-public-sub-1-a"  {
    subnet_id = aws_subnet.my-public-sub-1.id
    route_table_id = aws_route_table.my-public-rt.id
}

