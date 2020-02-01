variable "name" { }
variable "env" { }
variable "vpc" { }
variable "region" { }
variable "node_count" { }
variable "master_count" { }
variable "key_name" { }
variable "volume_size" { } 
variable "subnet_list" { type = list }
variable "instance_type" { }
variable "bucket_name" { default = "elasticsearch-certs" }
variable "master_allocid" { type = list }
variable "node_allocid" { type = list }
