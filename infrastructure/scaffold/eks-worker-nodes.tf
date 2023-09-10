# Two node groups, one per subnet (The two existing subnets are in different AZs)
# If the nodes are in private subnets without NAT or internet gateway, it need to reach EKS API somehow https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
resource "aws_eks_node_group" "node-group-0" {
  cluster_name    = resource.aws_eks_cluster.eks.name
  node_group_name = "${terraform.workspace}-master-node-group-0"
  node_role_arn   = aws_iam_role.legacy_eks-worker_role.arn

  # the for_each meta-arg created a map with two key-values pairs: {"us-east-1a" = {attributes of subnet-a(key:value)}, "us-east-1b" = {attributes of subnet-b(key:value)}}
  # values function get a map and return a list with the values of that map. [{attributes of subnet-a(key:value)}, {attributes of subnet-b(key:value)}]
  subnet_ids = [local.subnet_ids["us-east-1a"]]

  #subnet_ids      = [key(aws_subnet.eks_subnets)[0].id]       # using key function would work also (not tested)                                              
  capacity_type  = "SPOT"
  instance_types = ["t3.small", "t3a.small"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

resource "aws_eks_node_group" "node-group-1" {
  cluster_name    = resource.aws_eks_cluster.eks.name
  node_group_name = "${terraform.workspace}-master-node-group-1"
  node_role_arn   = aws_iam_role.legacy_eks-worker_role.arn

  # the for_each meta-arg created a map with two key-values pairs: {"us-east-1a" = {attributes of subnet-a(key:value)}, "us-east-1b" = {attributes of subnet-b(key:value)}}
  # values function get a map and return a list with the values of that map. [{attributes of subnet-a(key:value)}, {attributes of subnet-b(key:value)}]
  subnet_ids = [local.subnet_ids["us-east-1b"]]

  #subnet_ids      = [key(aws_subnet.eks_subnets)[1].id]       # using key function would work also (not tested)
  capacity_type  = "SPOT"
  instance_types = ["t3.small", "t3a.small"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}