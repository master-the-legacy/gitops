# EKS features https://aws.amazon.com/eks/features/
# EKS keeps one single tenant control plane per cluster and make sure its high availability


### EKS Control Plane ###
resource "aws_eks_cluster" "eks_cluster" {
  name     = "legacy-eks"
  role_arn = aws_iam_role.legacy_eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet_1.id, aws_subnet.eks_subnet_2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
    #aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive = true
}


### EKS Managed Node Groups ###
# https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html

