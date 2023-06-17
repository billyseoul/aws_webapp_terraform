# Deploying resources in the us-east-1 region with AWS as the cloud provider. 
provider "aws" {
  region = "us-east-1"
}

# Create a VPC with the pre-built terraform module using the /25 space
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "webapp-vpc"
  cidr   = "10.0.0.0/25"

  availability_zones = ["us-east-1a", "us-east-1b"] # deploy in 2 AZ's
  private_subnets     = ["10.0.0.0/27", "10.0.0.32/27"]
  public_subnets      = ["10.0.0.64/27", "10.0.0.96/27"]

  enable_nat_gateway = true # This should enable a NAT Gateway for Internet access in private subnets
  single_nat_gateway = true # Using a single NAT gateway for the private subnets 

  tags = {
    Environment = "webapp-example"
  }
}

# Creating a security group for SSH access on port 22
resource "aws_security_group" "ssh" {
  name_prefix = "ssh"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "webapp-example"
  }
}

# Create an Aurora database cluster
# This should use a pre-built Terraform module for the cluster
module "aurora" {
  source   = "terraform-aws-modules/rds-aurora/aws"
  name     = "webapp-aurora-db"
  engine   = "aurora-postgresql" # Use the Aurora's PostgreSQL-compatible engine
  version  = "10.14"
  db_subnet_group_name = module.vpc.db_subnet_group_name
  vpc_id             = module.vpc.vpc_id
  instance_count     = 2
  instance_type      = "db.r5.large"
  username           = "your_username"
  password           = "your_password"

  tags = {
    Environment = "webapp-aurora"
  }
}

# Creating the security group for the web app
resource "aws_security_group" "webapp_sg" {
  name_prefix = "webapp"
  vpc_id      = module.vpc.vpc_id

 
