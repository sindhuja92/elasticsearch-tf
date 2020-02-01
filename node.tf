# EC2 bootstrapping

data "template_file" "node_instance_bootstrap" {
  template = file("templates/node_user_data.tpl")
  vars = {
      bucket_name = (var.bucket_name)
      securitygroup_id = (aws_security_group.default.id)
      region = (var.region)
      env = (var.env)
      node_name = "node-[count.index]"
  }
}

resource "random_shuffle" "node_subnets" {
  input = (var.subnet_list)
  result_count = (var.node_count)
}

resource "aws_instance" "node" {
  count = (var.node_count)
  ami = (data.aws_ami.default.id)
  instance_type = (var.instance_type)
  associate_public_ip_address = "true"
  key_name = (var.key_name)
  vpc_security_group_ids = [(aws_security_group.default.id)]
  iam_instance_profile = (aws_iam_instance_profile.default.id)
  subnet_id = element(random_shuffle.subnets.result, count.index)
  user_data = (data.template_file.node_instance_bootstrap.rendered)

  root_block_device {
    volume_size = (var.volume_size)
  }

  lifecycle  {
    ignore_changes = [
      ami,
      user_data
    ]
  }

  tags = {
    Name = "${var.name}-node-${count.index}"
    Env = (var.env)
  }

}

resource "aws_eip_association" "node_eip_assoc" {
  count = (var.node_count)
  instance_id   = aws_instance.node[count.index].id
  allocation_id = (var.node_allocid[count.index])
}