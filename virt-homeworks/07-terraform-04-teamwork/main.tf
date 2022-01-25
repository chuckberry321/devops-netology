provider "aws" {
	region = "us-east-2"
}

data "aws_ami" "ubuntu_latest"{
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"
  monitoring             = true

  tags = {
     Terraform   = "true"
     Environment = "dev"
     Owner       = "Alexander Orekhov"
   }
}
