variable aws_region {
  description = "AWS region the terraform will be applied to"
}

variable vpc_cidr {
  description = "VPC CIDR block"
}

variable subnet_count {
  description = "Amount of subnets to be created for each private/public"
}