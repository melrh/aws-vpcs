# Cloudformation

This folder contains a number of Cloudformation stacks which create a variety of VPCs.

To build any of the Cloudformation stacks, use the following command.

`aws cloudformation create-stack --stack-name nameTheStack --template-body file://(path/to/the/stack) --profile yourIAMprofile`

### Basic VPC

In the `basic-vpc.yml` stack, this creates a very simple VPC. The VPC created is composed of:
  - A Public Subnet
  - A Private Subnet
  - An Internet Gateway
  - A NAT Gateway
  - A Public Route
  - A Private Route Table

### VPC with EC2

The `vpc-ec2.yml` stack is the exact same as the Basic VPC, except in addition it creates:
 - A Security Group
 - An EC2 Instance
