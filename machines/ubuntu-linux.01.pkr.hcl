
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


source "amazon-ebs" "mv-ubuntu" {

  ami_name      = "mv-ubuntu-${local.timestamp}"
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
  name    = "mv-packer-ubuntu"
  sources = [ "source.amazon-ebs.mv-ubuntu" ]

  provisioner "file" {
    source      = "../tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }

  provisioner "shell" {
    script = "../scripts/setup.sh"
  }

  provisioner "shell" {
    inline = [
      "/bin/echo --- Machine details",
      "/bin/date",
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


