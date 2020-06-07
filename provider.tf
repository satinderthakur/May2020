# AWS Provider for terraform connectivity

provider "aws"  {
  region                 = var.AWS_DEFAULT_REGION
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}


