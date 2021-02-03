resource "aws_iam_policy" "worker_policy" {
  name        = "eks-worker-policy"
  description = "EKS worker policy for the ALB Ingress"
  policy      = data.aws_iam_policy_document.eks_worker_policy.json
}
