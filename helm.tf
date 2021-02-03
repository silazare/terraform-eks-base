// Need to install ALBv2 CRDs
// https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/crds/crds.yaml
resource "helm_release" "ingress" {
  name       = "ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  version    = "1.1.2"

  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  depends_on = [
    module.eks,
    null_resource.target_group_crd
  ]
}
