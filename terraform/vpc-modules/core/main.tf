resource "aws_vpc" "main" {
    cidr_block  =   var.vpc_cidr

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id  =   aws_vpc.main.id

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_subnet" "public" {
    vpc_id      =   aws_vpc.main.id
    count       =   var.subnet_count
    cidr_block  =   cidrsubnet(var.vpc_cidr, 8, count.index)

    tags = {
        Name    =   "terraform_lab"
    }   
}

resource "aws_subnet" "private" {
    vpc_id      =   aws_vpc.main.id
    count       =   var.subnet_count
    cidr_block  =   cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_default_route_table" "default_route" {
    default_route_table_id  =   aws_vpc.main.default_route_table_id
    
    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   aws_internet_gateway.ig.id
    }

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_route_table_association" "default_rt_assoc" {
    count           =   var.subnet_count
    subnet_id       =   element(aws_subnet.public.*.id, count.index)
    route_table_id  =   aws_default_route_table.default_route.id
}

resource "aws_eip" "nat_eip" {
    vpc     =   true

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id   =   aws_eip.nat_eip.id
    subnet_id       =   aws_subnet.private.*.id[0]

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id  =   aws_vpc.main.id

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   aws_nat_gateway.nat_gw.id
    }

    tags = {
        Name    =   "terraform_lab"
    }
}