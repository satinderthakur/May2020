resource "aws_instance" "traning_instance"  {
  ami        = var.amis
  instance_type = var.instance_type

# the public SSH key
key_name = aws_key_pair.mykeypair.key_name

tags = {
 Name = "training_instance"
}

 user_data = <<-EOF
             #!/bin/bash
             yum update -y
             yum install httpd -y
             service httpd start
             service httpd on
             echo "Hello World" > /var/www/html/index.html
             sudo yum update -y
             amazon-linux-extras install docker -y
             service docker start
             usermod -a -G docker ec2-user
             service docker enable",
             $(aws ecr get-login --no-include-email --region us-east-1)",
             docker pull 235190073377.dkr.ecr.us-east-1.amazonaws.com/demo:latest
             docker container run -itd -p 8080:8080 235190073377.dkr.ecr.us-east-1.amazonaws.com/demo:latest
             EOF

}  
