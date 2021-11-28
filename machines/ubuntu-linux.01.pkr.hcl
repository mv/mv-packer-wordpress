
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

## Variables

locals {
  t1 = regex_replace(timestamp(), "[Z]", "" )
  t2 = regex_replace(local.t1   , "[:]", "-")
  timestamp = local.t2
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
#

# Source: AMI Filter
# aws ec2 describe-images \
#   --owners 099720109477 \
#   --filters \
#       "Name=virtualization-type,Values=hvm" \
#       "Name=root-device-type,Values=ebs"    \
#       "Name=name,Values=ubuntu-minimal/images/*ubuntu-focal-20.04-*" \
#   --query 'Images[*].[OwnerId,Architecture,VirtualizationType,Name,ImageId]' \
#   --output text | sort
#

source "amazon-ebs" "mv-ubuntu" {

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/*ubuntu-hirsute-21.04-*"
#     name                = "ubuntu/images/*ubuntu-focal-20.04-*"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  ami_name      = "mv-ubuntu-${local.timestamp}"
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

}

build {
  name    = "mv-packer-ubuntu-21"
  sources = [ "source.amazon-ebs.mv-ubuntu" ]

  provisioner "file" {
    source      = "../scripts/"
    destination = "/tmp/tf-packer.pub"
  }

  provisioner "shell" {
    script = "../scripts/setup.sh"
  }

  provisioner "shell" {
    inline = [
      "/bin/echo --- Machine details",
      "/bin/cat /etc/os-release",
      "/bin/echo --- Filesystem",
      "/bin/df -h | /bin/egrep -v loop",
      "/bin/echo --- CPU",
      "/bin/cat /proc/cpuinfo | /bin/egrep -i '^cpu|model' | sort",
      "/bin/echo",
    ]
  }

  provisioner "shell" {
    inline = [
      "/bin/echo --- Update OS",
      "DEBIAN_FRONTEND=noninteractive /usr/bin/sudo apt-get -y update",
      "DEBIAN_FRONTEND=noninteractive /usr/bin/sudo apt-get -y upgrade",
    ]
  }

  provisioner "shell" {
    inline = ["echo Finished: $( date )"]
  }

}


