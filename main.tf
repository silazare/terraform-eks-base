module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name                 = "${var.cluster_name}-vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  // EKS Managed Node groups
  node_groups = {
    first = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_type = var.instance_type

      additional_tags = {
        Role = "worker-ondemand"
      }
    }
    second = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_types = [var.instance_type]
      capacity_type  = "SPOT"

      additional_tags = {
        Role = "worker-spot"
      }
    }
  }

  write_kubeconfig   = true
  config_output_path = "./"

  workers_additional_policies = [aws_iam_policy.worker_policy.arn]

  tags = {
    Name        = var.cluster_name
    Terraform   = "true"
    Environment = "staging"
  }

  depends_on = [module.vpc]
}

// Workaround for TargetGroupBinding CRDs installation
resource "null_resource" "target_group_crd" {
  provisioner "local-exec" {
    command = "kubectl apply -k 'github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master' --kubeconfig kubeconfig_${var.cluster_name}"
  }

  triggers = {
    "eks_endpoint" = module.eks.cluster_endpoint
  }

  depends_on = [module.eks]
}
