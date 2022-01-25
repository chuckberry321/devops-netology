terraform {
  backend "s3" {
    bucket         = "netology.bucket"
    encrypt        = false
    key            = "netology-bucket/terraform.tfstate"
    region	   = "us-east-2"
  }
}
