resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.servicename}-cluster001"
  role_arn = aws_iam_role.aws_iam_role_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  

  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler"]
  
  depends_on = [
    aws_cloudwatch_log_group.ekscluster-cluster-log-group,
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}




resource "aws_cloudwatch_log_group" "ekscluster-cluster-log-group" {

  name              = "/aws/eks/${var.servicename}/cluster001"
  retention_in_days = 7
  # force_destroy = true

}


resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = "${var.servicename}-cluster001"
  addon_name        = "kube-proxy"
  addon_version     = "v1.30.0-eksbuild.3" # 원하는 버전으로 변경 가능
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = "${var.servicename}-cluster001"
  addon_name        = "vpc-cni"
  addon_version     = "v1.18.1-eksbuild.3" # 원하는 버전으로 변경 가능
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name      = "${var.servicename}-cluster001"
  addon_name        = "eks-pod-identity-agent"
  addon_version     = "v1.3.0-eksbuild.1"
}



