#Security Group

resource "aws_security_group" "my-web-ssh-sg" {
  vpc_id = aws_vpc.myVPC.id
  name = "my-web-ssh-sg"
  description = "security group that allow ssh and all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "my-web-ssh-sg"
  }
}
