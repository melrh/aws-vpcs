# Terraform

These directories were developed using Terraform version 0.11.13

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


### VPC with EC2

This directory creates the exact same infrastructure as the Basic VPC, however it additionally creates: 

    - an EC2 instance in a public subnet

The most recent Ubuntu AMI is pulled from AWS and is launched as the EC2 instance.

### VPC I/O

The terraform for this VPC is split up into modules, rather than being located in one main.tf file. Variables are passed between modules by using the `_interface.tf` and `outputs.tf` files. The directory structure is as follows:

```
.
├── _interface.tf
├── core
│   ├── _interface.tf
│   ├── main.tf
│   └── outputs.tf
├── front
│   ├── _interface.tf
│   ├── main.tf
│   └── outputs.tf
├── main.tf
├── terraform.tfvars
└── variables.tf
```

The Core Module creates: 

    - VPC
    - 2 Public Subnets (dynamically created)
    - 2 Private Subnets (dynamically created)
    - Internet Gateway
    - Public Route Table
    - NAT Gateway attached to 1 Private Subnet
    - Private Route Table
  
The Front Module creates what will be present in the public subnets. This includes:

    - Load Balancer
    - Autoscaling Group
    - Instance Launch Configuration

The Instance Launch Configuration is used to launch EC2 instance(s) which use the most recent Ubuntu AMI. These instances can be launched in either of the 2 public subnets which are covered by the Load Balancer and the Autoscaling Group.