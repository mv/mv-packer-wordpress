
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

variables {
  os_version = "20.04"
  os_owners  = ["099720109477"]
}

locals {
  timestamp = formatdate( "YYYY-MM-DD'T'hh.mm.ss.Z", timestamp())
}

## Data Source

source "amazon-ebs" "wp-ubuntu" {

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/*ubuntu-*-${var.os_version}-*"
    }
    owners      = "${var.os_owners}"
    most_recent = true
  }

  ami_name      = "wp-ubuntu-${var.os_version}-${local.timestamp}"
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

}

build {
  name    = "packer-wp-ubuntu"
  sources = [ "source.amazon-ebs.wp-ubuntu" ]

  provisioner "file" {
    direction   = "upload"
    destination = "/tmp/"
    sources = [
      "../config/dev.apache.wordpress.conf",
      "../config/localhost-selfsigned-cert.pem",
      "../config/localhost-selfsigned-priv.key",
      "../scripts/s3-get-files.sh",
    ]
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

  provisioner "breakpoint" {
    disable = true
    note    = "Breakpoint: to troubleshoot 'first' executions"
  }

}


