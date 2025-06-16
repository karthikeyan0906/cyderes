# Terraform project – launch an ec2 instance in aws

This is a simple terraform project that creates one ec2 instance in aws. it uses an s3 bucket to store the terraform state file so your changes stay in sync, even if you work on it from different places.

 main idea was to automate setting up a virtual machine (ec2) that i could connect to using ssh. i also used variables to make it easier to change things like the instance type or key name later.

---

## resources i have used

- uses the aws provider
- stores the terraform state file in an s3 bucket (remote backend)
- launches a t2.micro amazon linux 2 ec2 instance using a dynamic ami lookup
- sets up a security group that allows ssh (port 22) only from my public ip
- shows some useful outputs like instance id and public ip when done

---

## how it's set up

- the ec2 instance runs in the default vpc (which already has a public subnet)
- the ami is pulled using a data block so it's always up to date
- the ssh key used is called `test`, which i manually created in the aws console
- i'm using a small instance type (`t2.micro`) to stay within the free tier
- security group allows ssh from my ip only, and outbound access is fully open
- instance type and key name are passed in as variables

---

## how to run this

1. create an s3 bucket to store the terraform state file
2. generate an ssh key in aws naming it `test`
3. open the `variables.tf` file and update these if needed:
   - instance_type
   - key_name
4. then in your terminal, run:
   terraform init #initialize the provider,backend
   terraform plan 
   terraform apply 
