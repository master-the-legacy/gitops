### EKS Control Plane ###
data "aws_iam_policy_document" "assume_eks_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "legacy_eks_role" {
  name               = "legacy-eks-role"
  assume_role_policy = data.aws_iam_policy_document.assume_eks_role.json
}

# https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.legacy_eks_role.name
}

# Optionally, enable Security Groups for Pods
# https://aws.amazon.com/blogs/containers/introducing-security-groups-for-pods/

# resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.example.name
# }