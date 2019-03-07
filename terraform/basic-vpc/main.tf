provider aws {
    profile =   "${var.aws_profile}"
    region  =   "${var.aws_region}"
}

resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc_cidr}"

    tags {
        Name    =   "Main"
    }
}