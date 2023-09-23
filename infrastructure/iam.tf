# Create an IAM user for local test using terraform
resource "aws_iam_user" "tf-user" {
  name = "tf-user"
}

# Attach the AdministratorAccess Policy to the IAM user
resource "aws_iam_user_policy_attachment" "policy-attachment" {
  user       = aws_iam_user.tf-user.name
  policy_arn = data.aws_iam_policy.adm.arn
}