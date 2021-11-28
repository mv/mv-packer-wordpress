
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
#
#   cmdline: Source: AMI Filter
#   aws ec2 describe-images \
#     --owners 099720109477 \
#     --filters \
#         "Name=virtualization-type,Values=hvm" \
#         "Name=root-device-type,Values=ebs"    \
#         "Name=name,Values=ubuntu-minimal/images/*ubuntu-*-21.04-*" \
#     --query 'Images[*].[OwnerId,Architecture,VirtualizationType,Name,ImageId]' \
#     --output text | sort
#

source "amazon-ebs" "wp-ubuntu" {

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/*ubuntu-*-21.04-*"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  ami_name      = "wp-ubuntu-${local.timestamp}"
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

}

build {
  name    = "wp-packer-ubuntu-21"
  sources = [ "source.amazon-ebs.wp-ubuntu" ]

  provisioner "file" {
    source      = "../config/apache-wordpress.conf"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "../config/wp-config.php"
    destination = "/tmp/"
  }

  provisioner "shell" {
    script = "../scripts/wp-install.ubuntu.sh"
  }

  provisioner "shell" {
    inline = [
      "/bin/echo --- Machine details",
      "/bin/cat /etc/os-release",
      "/bin/echo --- CPU",
      "/bin/cat /proc/cpuinfo | /bin/egrep -i '^cpu|model' | sort",
      "/bin/echo",
    ]
  }

}


