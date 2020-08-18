variable "vpc_cidr" {
    description = "The VPC's CIDR block"
    type = string
}

variable "vpc_id" {
    description = "The VPC's ID"
    type = string
}

variable "pubsub_ids" {
    description = "A list of Public Subnet IDs"
    type    =   list(any)
}

variable "ssh_ip" {
    description = "The IP used for SSH"
    type = string
}