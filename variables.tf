variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-test"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.18"
}

variable "instance_type" {
  description = "EKS worker instance type"
  type        = string
  default     = "t3.small"
}
