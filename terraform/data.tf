provider "aws" {
  region = "ap-south-1"
}


data "aws_vpc" "main" {
  tags = {
    name = "default"
  }
}


data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.main.id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

