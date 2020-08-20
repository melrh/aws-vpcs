variable "aws_region" {
    description =   "The aws region to build the stack in"
    type = string
}

variable "vpc_cidr" {
    description =   "The cidr block of the vpc"
    type = string
}

variable "subnet_count" {
    description =   "The amount of each public & private subnets to create"
    type = string
}