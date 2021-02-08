## AWS EKS cluster example (using public modules)

EKS cluster provision from public modules and ALB Ingress Controller provision from Helm provider.

Prerequisites:
* terraform >= 0.13
* kubectl
* [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

Pre-commit installation:
```shell
git secrets --install
pre-commit install -f
pre-commit run -a
```

Key points:
* VPC resources are managed in standalone public module
* Full managed AWS EKS with Spot and On-demand managed node_groups
* ALB v2 ingress controller with Target Groups CRD (workaround via null_resource)

## Create/Destroy Staging Infrastructure:

1) Create Staging VPC and EKS cluster
```shell
make plan
make apply
```

As soon as cluster is ready, you should find a `kubeconfig_*` kubeconfig file in the current directory.
Please note that test cluster is Public by default !!!

2) Destroy Staging VPC and EKS cluster
```shell
make destroy
```

## Example application deploy for Ingress testing:
1) Go to example-app folder
```shell
cd example-app
```

2) Apply manifests
```shell
kubectl apply -f . 
```

3) Check ingress
```shell
kubectl get ing 
```

4) Test endpoints
```shell
curl <ALB Ingress FQDN>/apple
curl <ALB Ingress FQDN>/banana
```

5) Destroy manifests
```shell
kubectl delete -f .
```
