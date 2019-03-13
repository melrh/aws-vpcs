variable "aws_profile" {
    description =   "The aws profile that terraform will use to build"
}

variable "aws_region" {
    description =   "The aws region to build the stack in"
}

variable "vpc_cidr" {
    description =   "The cidr block of the vpc"
}

variable "subnet_count" {
    description =   "The amount of each public & private subnets to create"
}