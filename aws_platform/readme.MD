# EKS Cluster Module

This Terraform module creates an AWS EKS cluster with the following features:
- Managed EKS cluster
- Configurable managed node groups
- IAM roles and policies
- Support for custom tags and networking configurations

## Inputs

| Name           | Description                            | Type               | Default | Required |
|----------------|----------------------------------------|--------------------|---------|----------|
| cluster_name   | The name of the EKS cluster            | `string`           | -       | yes      |
| region         | AWS region for the EKS cluster         | `string`           | -       | yes      |
| vpc_id         | The ID of the VPC for the EKS cluster  | `string`           | -       | yes      |
| subnet_ids     | A list of subnet IDs                   | `list(string)`     | -       | yes      |
| node_groups    | Map of node group configurations       | `map(object({...}))| -       | yes      |
| enable_logging | Enable control plane logging           | `bool`             | true    | no       |
| tags           | Map of tags                           | `map(string)`      | `{}`    | no       |

## Outputs

| Name               | Description                       |
|--------------------|-----------------------------------|
| cluster_id         | ID of the EKS cluster            |
| cluster_endpoint   | API endpoint for the EKS cluster |
| cluster_arn        | ARN of the EKS cluster           |
| node_group_arns    | ARNs of the managed node groups   |

## Usage

```hcl
module "eks_cluster" {
  source = "./eks-cluster"

  cluster_name   = "my-eks-cluster"
  region         = "us-east-1"
  vpc_id         = "vpc-12345678"
  subnet_ids     = ["subnet-abc123", "subnet-def456"]
  enable_logging = true
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
  node_groups = {
    group1 = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      labels = {
        role = "web"
      }
      tags = {
        Name = "web-nodes"
      }
    }
    group2 = {
      desired_size   = 3
      max_size       = 5
      min_size       = 2
      instance_types = ["t3.medium"]
      labels = {
        role = "backend"
      }
      tags = {
        Name = "backend-nodes"
      }
    }
  }
}
