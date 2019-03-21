provider "aws" {
    profile =   "${var.aws-profile}"
    region  =   "${var.aws-region}"
}

module "core" {
    source          =   "core"
    vpc-cidr        =   "${var.vpc-cidr}"
    subnet-count    =   "${var.subnet-count}"
}

module "front" {
    source          =   "front"
    vpc-cidr        =   "${var.vpc-cidr}"
    vpc-id          =   "${module.core.vpc-id}"
    pubsub-ids      =   "${module.core.pubsub-ids}"
}