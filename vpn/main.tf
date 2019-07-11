locals {
  region = "ap-southeast-2"
  instance_type = "t2.micro"
  ami_id = "ami-000c2343cf03d7fd7"
}


provider "aws" {
  region = "${local.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "access-https-ssh" {
  name = "access-https-ssh"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
    template = "${file("${path.module}/vpn_setup.sh")}"
}


resource "aws_instance" "vpn_instance" {

  provider = "aws"
  ami = "${local.ami_id}"
  instance_type = "${local.instance_type}"
  key_name = "my"
  
  security_groups = [ "access-https-ssh" ]

  user_data = "${data.template_file.user_data.rendered}"

}
