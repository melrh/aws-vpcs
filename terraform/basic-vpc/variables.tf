variable aws_profile {
  description = "IAM profile used to run terraform"
}

variable aws_region {
  description = "AWS region the terraform will be applied to"
}

variable vpc_cidr {
  description = "VPC CIDR block"
}

variable subnet_count {
  description  =  "Amount created for each private/public subnet"
}