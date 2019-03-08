# Terraform

This folder contains a number of terraform stacks that will be deployed in AWS. The terraform scripts are currently run under my specific aws profile which is set in the `terraform.tfvars` file, however this must be changed to your own aws profile in order for the script to run.

To build any of the aws stacks, run the terraform script. Enter into the directory of the terraform script you want to run, and run the following commands:

```
terraform init
terraform plan
```
The plan will show an output in your console of what will be built in aws. After viewing the plan, you can then run:

`terraform apply`

This will build the stack in aws. The resources will vary depending on which terraform directory you are building from. Finally, to clean up the resources built in aws, run:

`terraform destroy`

This will destroy everything built by the specific terraform stack.

### Basic VPC

This directory creates:

    - VPC
    - 2 Public Subnets (dynamically created)
    - 2 Private Subnets (dynamically created)
    - Internet Gateway
    - Public Route Table
    - NAT Gateway attached to 1 Private Subnet
    - Private Route Table