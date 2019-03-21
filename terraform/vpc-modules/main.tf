provider "aws" {
    profile =   "${var.aws-profile}"
    region  =   "${var.aws-region}"
}

module "core" {
    source          =   "core"
    vpc-cidr        =   "${var.vpc-cidr}"
    subnet-count    =   "${var.subnet-count}"
}