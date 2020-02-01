provider "aws" {
	region = (var.region)
  access_key = "access_key"
  secret_key = "secret_key"
}

#terraform {
#	backend "s3" {
#	  bucket = "tf-remote-state-s3-bucket"
#	  key    = "elasticsearch/terraform.tfstate"
#	  region = "us-east-1"
#	}
#}


resource "aws_iam_role" "default" {
	name = "${var.name}-role"
	assume_role_policy = file("policies/role.json")
	tags = {
    Name = "${var.name}-role"
    Env  = (var.env)
  }
}

resource "aws_iam_role_policy" "default" {
	name = "${var.name}-policy"
  role = aws_iam_role.default.name
	policy = file("policies/role-policy.json")
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.name}-instance-profile"
  path = "/"
  role = aws_iam_role.default.name
}

resource "aws_security_group" "default" {
	name = "${var.name}-sg"
	vpc_id = (var.vpc)

	ingress {
	  from_port = 9200
	  to_port = 9200
	  protocol = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	  from_port = 9300-9400
	  to_port = 9300-9400
	  protocol = "tcp"
	  self = true
	}

	ingress {
	  from_port = 22
	  to_port = 22
	  protocol = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
	  from_port = 0
	  to_port = 0
	  protocol = -1
	  cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
    Name = "${var.name}-sg"
    Env  = (var.env)
  }
}
