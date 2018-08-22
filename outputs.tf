output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "aws_route_table" {
  value = "${aws_route_table.pub_rt.id}"
}

#output "nat_eip" {
#  value = "${join(",", aws_eip.nateip.*.id)}"
#}

#output "nat_gateway_id" {
#  value = "${join(",", aws_nat_gateway.natgateway.*.id)}"
#}
