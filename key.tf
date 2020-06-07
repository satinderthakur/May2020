resource "aws_key_pair" "mykeypair"{
  key_name = "EC2-Key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
