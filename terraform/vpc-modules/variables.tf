variable "aws-profile" {
    description =   "The IAM user profile used to build the infrastructure"
}

variable "aws-region" {
    description =   "The region the vpc will be built in"
}

variable "vpc-cidr" {
    description =   "The cidr block reserved for the vpc"
}

variable "subnet-count" {
    description =   "The amount of each public & private subnets that will be created"
}