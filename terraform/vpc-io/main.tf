provider "aws" {
    profile =   "${var.aws_profile}"
    region  =   "${var.aws_region}"
}

module "core" {
    source          =   "core"
    vpc_cidr        =   "${var.vpc_cidr}"
    subnet_count    =   "${var.subnet_count}"
}
/*
module "front" {
    source      =   "front"
    vpc_cidr    =   "${var.vpc_cidr}"
    vpc_id      =   "${module.core.vpc_id}"
    pubsub_ids  =   "${module.core.pubsub_ids}"
}
*/