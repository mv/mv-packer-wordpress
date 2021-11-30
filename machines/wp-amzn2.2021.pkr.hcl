
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
  os_version = "2.0"
  os_owners  = ["amazon"]
}

locals {
  timestamp = formatdate( "YYYY-MM-DD'T'hh-mm-ssZ", timestamp())
}

## Data Source

source "amazon-ebs" "wp-amzn2" {

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
#     architecture        = "arm64"
      architecture        = "x86_64"
      name                = "amzn2-ami-minimal-hvm*${var.os_version}*"
    }
    owners      = "${var.os_owners}"
    most_recent = true
  }

  ami_description = "Wordpress"
  ami_name      = "wp-amzn2-${var.os_version}-${local.timestamp}"
  region        = "us-east-1"
# instance_type = "t4g.micro"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"

  tags = {
    Name = "wp-amzn2"
    App = "wordpress"
  }

}

build {
  name    = "packer-wp-amzn2"
  sources = [ "source.amazon-ebs.wp-amzn2" ]

  provisioner "shell-local" {
    inline = [
      "echo 'SSH Private Key: '",
      "echo '${build.SSHPrivateKey}'",
      "echo '${build.SSHPrivateKey}' > ./ec2-packer-session.pem",
      "echo 'ssh -i ec2-packer-session.pem -l ${build.User} ${build.Host}'"
      "chmod 600 ./ec2-packer-session.pem",
    ]
  }

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
    script = "../scripts/wp-install.amzn2.sh"
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
    disable = false
    note    = "Breakpoint: ssh -i ec2-packer-session.pem -l ${build.User} ${build.Host}"
  }

}


