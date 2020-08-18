variable "vpc_cidr" {
    description =   "The cidr block reserved for the vpc"
    type = string
}

variable "subnet_count" {
    description =   "The amount of each public & private subnets that will be created"
    type = string
}