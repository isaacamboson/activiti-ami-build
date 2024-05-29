variable "aws_source_ami" {
  # default = "amzn2-ami-hvm-2.0.20210326.0-x86_64-gp2"
  #default = "amzn2-ami-kernel-5.10-hvm-2.0.20240329.0-x86_64-gp2"
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20240228"
}

variable "aws_instance_type" {
  default = "t2.small"
}

variable "ami_name" {
  # default = "ami-stack-1.2"
  default = "ami-stack-51"
  #default = "ami-activiti-1.1"
}

variable "component" {
  default = "activiti"
}

variable "aws_accounts" {
  type = list(string)
  # default= ["992382477605","560089993749"]
  default= ["992382477605", "767398027423"]
}

variable "ami_regions" {
  type = list(string)
  default =["us-east-1"]
}

variable "aws_region" {
  default = "us-east-1"
}

data "amazon-ami" "source_ami" {
  filters = {
    name = "${var.aws_source_ami}"
  }
  most_recent = true
  owners      = ["336528460023","amazon"]
  region      = "${var.aws_region}"
}

# locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.

source "amazon-ebs" "amazon_ebs" {
  # assume_role {
  #   role_arn     = "arn:aws:iam::560089993749:role/Engineer"
  # }
  ami_name                = "${var.ami_name}"
  ami_regions             = "${var.ami_regions}"
  ami_users               = "${var.aws_accounts}"
  snapshot_users          = "${var.aws_accounts}"
  encrypt_boot            = false
  instance_type           = "${var.aws_instance_type}"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    encrypted             = false
    volume_size           = 10
    volume_type           = "gp2"
  }
  region                  = "${var.aws_region}"
  source_ami              = "${data.amazon-ami.source_ami.id}"
  ssh_pty                 = true
  ssh_timeout             = "5m"
  ssh_username            = "ubuntu"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.amazon_ebs"]
  provisioner "shell" {
    script = "../scripts/setup.sh"
  }
}
