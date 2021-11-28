
## Builder plugin: Amazon

packer {

  # plugin: amazon-ebs
  # https://www.packer.io/docs/builders/amazon
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }

}

## Data Source
# Amazon AMI Data Source
# https://www.packer.io/docs/datasources/amazon/AMI

# data "amazon-ami" "basic-example" {
#     filters = {
#         virtualization-type = "hvm"
#         name = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#         root-device-type = "ebs"
#     }
#     owners = ["099720109477"]
#     most_recent = true
# }


source "amazon-ebs" "mv-ubuntu" {

  ami_name      = "mv-ubuntu"
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

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


