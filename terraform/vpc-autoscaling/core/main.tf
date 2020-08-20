resource "aws_vpc" "main" {
    cidr_block  =   var.vpc_cidr

    tags = {
        Name    =   "Main_VPC"
        Project = "Terraform_Lab"
    }
}

resource "aws_subnet" "public" {
    count       =   var.subnet_count
    vpc_id      =   aws_vpc.main.id
    cidr_block  =   cidrsubnet(var.vpc_cidr, 8, count.index)

    tags = {
        Name    =   "PubSub${count.index + 1}"
        Project = "Terraform_Lab"
    }
}

resource "aws_subnet" "private" {
    count       =   var.subnet_count
    vpc_id      =   aws_vpc.main.id
    cidr_block  =   cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)

    tags = {
        Name    =   "PrivSub${count.index + 1}"
        Project = "Terraform_Lab"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id  =   aws_vpc.main.id

    tags = {
        Name    =   "Main_IG"
        Project = "Terraform_Lab"
    }
}

resource "aws_default_route_table" "default_route" {
    default_route_table_id  =   aws_vpc.main.default_route_table_id

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   aws_internet_gateway.ig.id
    }

    tags = {
        Name    =   "Internet_Route"
        Project = "Terraform_Lab"
    }
}

resource "aws_route_table_association" "ig_assoc" {
    count           =   var.subnet_count
    subnet_id       =   element(aws_subnet.public.*.id, count.index)
    route_table_id  =   aws_default_route_table.default_route.id
}

resource "aws_eip" "nat_eip" {
    vpc =   true

    tags = {
        Name    =   "NAT_EIP"
        Project = "Terraform_Lab"
    }
}

resource "aws_nat_gateway" "nat" {
    subnet_id       =   aws_subnet.private.*.id[0]
    allocation_id   =  aws_eip.nat_eip.id

    tags = {
        Name    =   "NAT_Gateway"
        Project = "Terraform_Lab"
    }
}

resource "aws_route_table" "nat_route" {
    vpc_id  =   aws_vpc.main.id

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   aws_nat_gateway.nat.id
    }

    tags = {
        Name    =   "NAT_Route"
        Project = "Terraform_Lab"
    }
}