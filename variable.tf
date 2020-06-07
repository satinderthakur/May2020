#Variable Declaration

#FOR AWS provider

variable "AWS_DEFAULT_REGION" {
  default   = "us-east-1"
  description = "Default AWS Region"
}

variable "shared_credentials_file" {
  default   = "C:/Users/training/.aws/credentials" 
  description = "Shared AWS credentials file location"
}

variable "profile"  {
  default   = "default"
  description = "Name of profile"
}

#For AWS EC2 Instance
variable "instance_type"  {
   default = "t2.micro"
}

variable "amis"  {
  default  = "ami-09d95fab7fff3776c"

}

variable "PATH_TO_PUBLIC_KEY" {
  default = "C:/Users/training/.aws/demod.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "C:/Users/training/.aws/demod"
}