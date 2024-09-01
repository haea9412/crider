resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.servicename}-cluster"
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

  name              = "/aws/eks/${var.servicename}/cluster"
  retention_in_days = 7

  lifecycle {
    prevent_destroy = true
  }


}




