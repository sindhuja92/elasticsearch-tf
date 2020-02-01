# EC2 bootstrapping

data "template_file" "master_instance_bootstrap" {
  template = file("templates/master_user_data.tpl")
  vars = {
      bucket_name = (var.bucket_name)
      securitygroup_id = (aws_security_group.default.id)
      region = (var.region)
      env = (var.env)
      node_name = "master"
  }
}

data "aws_ami" "default" {
  owners = ["137112412989"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.20191217.0-x86_64-gp2"]
  }
} 

resource "random_shuffle" "subnets" {
  input = (var.subnet_list)
  result_count = (var.master_count)
}


resource "aws_instance" "master" {
  count = (var.master_count)
  ami = (data.aws_ami.default.id)
  instance_type = (var.instance_type)
  associate_public_ip_address = "true"
  key_name = (var.key_name)
  vpc_security_group_ids = [(aws_security_group.default.id)]
  iam_instance_profile = (aws_iam_instance_profile.default.id)
  subnet_id = element(random_shuffle.subnets.result, count.index)
  user_data = (data.template_file.master_instance_bootstrap.rendered)

  root_block_device {
    volume_size = (var.volume_size)
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data
    ]
  }

  tags = {
    Name = "${var.name}-master"
    Env = (var.env)
  }

}

resource "aws_eip_association" "master_eip_assoc" {
  count = (var.master_count)
  instance_id   = aws_instance.master[count.index].id
  allocation_id = (var.master_allocid[count.index])
}


