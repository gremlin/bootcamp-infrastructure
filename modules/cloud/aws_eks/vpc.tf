
# We don't create a VPC for each environment. It doesn't make sense to provision dedicated VPC + networking for each bootcamp environment.

# Instead, we rely on the customer to pass in a VPC ID and optionally a list of subnet IDs for the VPC. If no subnet IDs are passed, then all subnets in the VPC will be used for the cluster.

# Retrieve into about VPC
#data "aws_vpc" "vpc" {
#    vpc_id = var.vpc_id
#}

data "aws_subnets" "all_vpc_subnets" {
    filter {
        name = "vpc-id"
        values = [
            var.vpc_id
        ]
    }
}

resource "aws_security_group" "global_http_access" {
    name = "group-${var.group_id}"
    description = "SG for Bootcamp Group ${var.group_id}"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    #tags = merge(
    #    {
    #        "Name": "group-${var.group_id}"
    #    },
    #    var.tags
    #)
}