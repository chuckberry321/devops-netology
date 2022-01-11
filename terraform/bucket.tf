terraform {
  backend "s3" {
    bucket         = "netology.bucket"
    encrypt        = false
    key            = "netology-игслуе/terraform.tfstate"
    region	   = "us-east-2"
  }
}
