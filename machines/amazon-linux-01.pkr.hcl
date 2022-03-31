
## Builder plugin: Amazon

packer {

  # plugin: amazon-ebs
  # https://www.packer.io/docs/builders/amazon
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }

}

source "amazon-ebs" "wp-amzn2" {

  ami_name      = "wp-amzn2"
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

}

build {
  name = "mv-packer-ubuntu"
  sources = [
    "source.amazon-ebs.mv-ubuntu"
  ]
}


