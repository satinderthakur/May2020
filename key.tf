resource "aws_key_pair" "mykeypair"{
  key_name = "EC2-Key_1"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
