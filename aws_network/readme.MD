# AWS Network Module

This Terraform module creates an AWS network infrastructure, including:
- A VPC
- Public and private subnets
- An optional NAT Gateway
- Internet Gateway
- Route tables and route table associations

## Inputs

| Name                  | Description                                | Type           | Default       | Required |
|-----------------------|--------------------------------------------|----------------|---------------|----------|
| vpc_cidr             | CIDR block for the VPC                    | `string`       | -             | yes      |
| azs                  | List of availability zones                | `list(string)` | -             | yes      |
| public_subnets_cidrs | List of CIDR blocks for public subnets     | `list(string)` | -             | yes      |
| private_subnets_cidrs| List of CIDR blocks for private subnets    | `list(string)` | -             | yes      |
| enable_nat_gateway    | Whether to enable NAT Gateway             | `bool`         | `true`        | no       |
| tags                 | Map of tags to apply to resources         | `map(string)`  | `{}`          | no       |

## Outputs

| Name              | Description                          |
|-------------------|--------------------------------------|
| vpc_id           | ID of the created VPC               |
| public_subnets   | IDs of public subnets               |
| private_subnets  | IDs of private subnets              |
| nat_gateway_id   | ID of the NAT Gateway (if enabled)  |
| route_table_public | ID of the public route table       |

## Usage

```hcl
module "aws_network" {
  source = "./aws-network"

  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs= ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway    = true
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
