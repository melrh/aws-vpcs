variable aws_region {
  description = "The region that the stack will be created in"
}

variable vpc_cidr {
  description = "The cidr for the vpc"
}

variable subnet_count {
  description = "How many subnets (of each public and private) to be created"
}