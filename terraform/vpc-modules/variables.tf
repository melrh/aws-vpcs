variable "aws_region" {
  description = "The region the vpc will be built in"
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr block reserved for the vpc"
  type        = string
}

variable "subnet_count" {
  description = "The amount of each public & private subnets that will be created"
  type        = string
}

variable "ssh_ip" {
  description = "My IP address for ssh access to the ec2 instance"
  type        = string
}

