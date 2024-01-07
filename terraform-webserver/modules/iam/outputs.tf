output "aws_access_key" {
  value = aws_iam_access_key.ec2_restart_user_access_key.id
}

output "aws_secret_key" {
  value = aws_iam_access_key.ec2_restart_user_access_key.secret
}