# EKS features https://aws.amazon.com/eks/features/
# EKS keeps one single tenant control plane per cluster and make sure its high availability


### EKS Control Plane ###
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${terraform.workspace}-master-cluster" # The name must be unique within the AWS Region and AWS account
  role_arn = aws_iam_role.legacy_eks_role.arn

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  kubernetes_network_config {
    # CIDR block to assign to Kubernetes pod and service IP address
    # Recommendation is to do not overlap any other resources in other network that is peered with the cluster VPC
    # Can't overlap with any CIDR block assigned to the cluster VPC
    # Need to be between /24 and /12
    service_ipv4_cidr = "10.100.0.0/16"
    ip_family         = "ipv4"
  }

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id # You can't change which subnets you want to use after cluster creation.
    endpoint_public_access = true # Enable EKS public API server endpoint
    public_access_cidrs = "0.0.0.0/0" # EKS API server endpoint source IP, could be used to allow only VPN
    # security_group_ids = [] TODO: make the cluster private
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
    #aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController
  ]

  version = "1.29" # no upgrades will occur except those automatically triggered by EKS

  tags = {
    product = "master-the-legacy"
    ctf     = "WW91IGdvdCBpdCEgbmljZS4="
  }
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value     = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive = true
}


### EKS Managed Node Groups ###
# https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html

