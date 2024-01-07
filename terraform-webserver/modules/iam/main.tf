resource "aws_iam_user" "ec2_restart_user" {
  name = format("%s-%s", var.common_name_prefix, "user")
}

resource "aws_iam_access_key" "ec2_restart_user_access_key" {
  user = aws_iam_user.ec2_restart_user.name
}

resource "aws_iam_user_policy_attachment" "ec2_restart_user_attachment" {
  user       = aws_iam_user.ec2_restart_user.name
  policy_arn = aws_iam_policy.ec2_restart_policy.arn
}

resource "aws_iam_policy" "ec2_restart_policy" {
  name        = format("%s-%s", var.common_name_prefix, "restart-policy")
  description = "Policy to allow restarting EC2 instances created with specific launch template"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:RebootInstances",
        Resource = "*",
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Name" = format("%s-%s", var.common_name_prefix, "ec2")
          }
        }
      },
    ],
  })
}