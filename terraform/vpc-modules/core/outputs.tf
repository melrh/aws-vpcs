output "vpc_id" {
    description = "The VPCs ID"
    value   =   aws_vpc.main.id
}

output "pubsub_ids" {
    description = "A list of the Public Subnet IDs"
    value   =   aws_subnet.public.*.id
}