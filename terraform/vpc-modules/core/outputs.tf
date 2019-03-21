output "vpc-id" {
    value   =   "${aws_vpc.main.id}"
}

output "pubsub-ids" {
    value   =   ["${aws_subnet.public.*.id}"]
}