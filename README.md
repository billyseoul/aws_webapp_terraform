# Overview:
The Terraform code is used to deploy resources in the us-east-1 region of AWS as the cloud provider. 
It sets up a VPC, creates security groups for SSH access and the web app, and provisions an Aurora database cluster.

# What it will create and its purpose:

Infrastructure: It provisions infrastructure resources in AWS, in the us-east-1 region.

VPC: It creates a Virtual Private Cloud (VPC) using a pre-built Terraform modules. 
The VPC is named webapp-vpc and includes private and public subnets spread across two AZ's. 
It will also enable a NAT Gateway for internet access in the private subnets.

Security Group: It creates a security group named SSH that allows access on port 22. The security group is associated with the VPC.

Aurora Database Cluster: It provisions an Aurora database cluster using a pre-built Terraform module. The cluster uses the Aurora PostgreSQL-compatible engine and consists of 2 database instances. The database cluster is named webapp-aurora-db and is also tied to the VPC.

Security Group for Web App: It creates a security group named webapp_sg associated with the VPC. This security group is intended for the web application.
