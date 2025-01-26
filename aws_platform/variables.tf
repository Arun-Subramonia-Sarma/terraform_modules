# variables.tf

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
    labels        = map(string)
    tags          = map(string)
  }))
}

variable "enable_logging" {
  description = "Enable control plane logging"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
