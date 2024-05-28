# variable "cidr_vpc" {
#   description = "CIDR block for the VPC"
#   default     = "10.1.0.0/16"
# }
# variable "cidr_subnet" {
#   description = "CIDR block for the subnet"
#   default     = "10.1.0.0/24"
# }

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region"{
  description = "The region Terraform deploys your instance"
  default     = "us-east-1"
}

variable "vpc_id"{
    # default="vpc-0befa9f9ff5d3b888"
    default = "vpc-0a707f97aa2c30e39"
}

variable "subnets" {
  type = list(string)
  default=[
    # "subnet-0a029f0722b30551b",
    # "subnet-0f809518c9e33b8d3",
    "subnet-003cebfc6e190e185",
    "subnet-065e7f86e003bce56"
   ]
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "ses_key.pub"
}

variable "ami_name" {
  default = "ami-stack-51"
}
