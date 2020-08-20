output "vpc_id" {
    value   =   aws_vpc.main.id
}

output "pubsub_ids" {
    value   =   aws_subnet.public.*.id
}

output "privsub_ids" {
    value   =   aws_subnet.private.*.id
}