# define & build the ecs cluster | ecs-cluster.tf
# create ecs cluster
resource "aws_ecs_cluster" "aws-ecs" {
  name = var.profile
}
# get latest ecs ami
data "aws_ami" "ecs-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}
# override ecs ami image
variable "aws_ecs_ami_override" {
  default = ""
  description = "Machine image to use for ec2 instances"
}
locals {
  aws_ecs_ami = var.aws_ecs_ami_override == "" ? data.aws_ami.ecs-ami.id : var.aws_ecs_ami_override
}
locals {
  ebs_types = ["t2"]
  cpu_by_instance = {
    "t2.small"     = 1024
    
  }
  mem_by_instance = {
    "t2.small"     = 1800
    
  }
}
# ecs cluster runner role policies
resource "aws_iam_role" "ecs-cluster-runner-role" {
  name = "${var.profile}-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role.json
}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "ecs-cluster-runner-policy" {
  statement {
    actions = ["ec2:Describe*", "ecr:Describe*", "ecr:BatchGet*"]
    resources = ["*"]
  }
  statement {
    actions = ["ecs:*"]
    resources = ["arn:aws:ecs:${var.AWS_DEFAULT_REGION}:${data.aws_caller_identity.current.account_id}:service/${var.profile}/*"]
  }
}
resource "aws_iam_role_policy" "ecs-cluster-runner-role-policy" {
  name = "${var.profile}-cluster-runner-policy"
  role = aws_iam_role.ecs-cluster-runner-role.name
  policy = data.aws_iam_policy_document.ecs-cluster-runner-policy.json
}
resource "aws_iam_instance_profile" "ecs-cluster-runner-profile" {
  name = "${var.profile}-cluster-runner-iam-profile"
  role = aws_iam_role.ecs-cluster-runner-role.name
}

# create ec2 instance for the ecs cluster runner
resource "aws_instance" "ecs-cluster-runner" {
  ami = local.aws_ecs_ami
  instance_type = var.instance_type
  subnet_id = element(aws_subnet.my-public-sub-1.*.id, 0)
  vpc_security_group_ids = [aws_security_group.ecs-cluster-host.id]
  associate_public_ip_address = true

  
  count = 1
  iam_instance_profile = aws_iam_instance_profile.ecs-cluster-runner-profile.name
  tags = {
    Name = "${var.profile}-ecs-cluster-runner"
   
    Role = "ecs-cluster"
  }
  volume_tags = {
    Name = "${var.profile}-ecs-cluster-runner"
    Role = "ecs-cluster"
  }
}
# create security group and segurity rules for the ecs cluster
resource "aws_security_group" "ecs-cluster-host" {
  name = "${var.profile}-ecs-cluster-host"
  description = "${var.profile}-ecs-cluster-host"
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "${var.profile}-ecs-cluster-host"
    Role = "ecs-cluster"
  }
}
resource "aws_security_group_rule" "ecs-cluster-host-ssh" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "admin SSH access to ecs cluster"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ecs-cluster-ingress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "admin SSH access to ecs cluster"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "ecs cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
# output ecs cluster public ip
output "ecs_cluster_runner_ip" {
  description = "External IP of ECS Cluster"
  value = [aws_instance.ecs-cluster-runner.*.public_ip]
}