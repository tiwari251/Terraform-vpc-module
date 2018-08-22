provider "aws" {
  region = "${var.aws_region}"
}

#data "terraform_remote_state" "vpc" {
#  backend = "s3"
#  config = {
#    bucket = "myvpcstate"
#    key = "vpc/terraform.tfstate"
#    region = "us-east-1"
#  }
#}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = "${var.enable_dns_hostname}"
  tags {
    Name = "${var.product_name}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.env_name}"
    Service = "${var.product_name}"
    Group = "${var.group_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.product_name}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.env_name}"
    Service = "${var.product_name}"
    Group = "${var.group_name}"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.product_name}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.env_name}"
    Service = "${var.product_name}"
    Group = "${var.group_name}"
  }
}

resource "aws_route" "pub_subnet_internet_gateway" {
  route_table_id = "${aws_route_table.pub_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
  depends_on = ["aws_route_table.pub_rt", "aws_internet_gateway.igw"]
}

resource "aws_main_route_table_association" "mrta" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}

########### NAT Gateway module ###########

resource "aws_eip" "nateip" {
  count = "${var.count}"
}

resource "aws_nat_gateway" "natgateway" {
  count = "$(var.count)"
  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id = "${element(split(",", terraform_}"
