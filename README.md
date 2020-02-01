# elasticsearch-tf

**Steps to setup a 1 master 2 node elasticsearch cluster**

1. Install terraform 0.12.17 on your machine.
2. Provide access key and secret key to authenticate to AWS.
3. Create a bucket to store the terraform remote state.
3. Create certificates for master and nodes and store them in s3 bucket.
4. Store a text file in s3 bucket which contains elastic user password used to reset the bootstrap password to access the cluster using credentials.
5. Create three elastic ip's and pass them as a list in .tfvars to associate them to the instances yet to be created.
6. Once all pre-requisites are complete run the following steps using terraform.


terraform init

terraform plan -var-file=env/dev.tfvars

terraform apply 

![alt text](https://github.com/sindhuja92/elasticsearch-tf/blob/master/Screen%20Shot%202020-01-31%20at%2010.25.12%20PM.png)
