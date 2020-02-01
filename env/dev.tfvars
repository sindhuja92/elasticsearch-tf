name = "elasticsearch"
env = "dev"
vpc = "vpc-4161aa27"
region = "us-east-1"
node_count = 2
subnet_list = ["subnet-4b36bd66", "subnet-6bd45e67", "subnet-76c8a713", "subnet-8855d9d3", "subnet-bd03a081", "subnet-f8dda7b1"]
instance_type = "t2.medium" 
master_count = 1
key_name = "elasticsearch"
volume_size = 8
master_allocid = ["eipalloc-04ef1fe36fc48bbbe"]
node_allocid = ["", ""]

