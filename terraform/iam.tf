
data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "secrets_manager_role" {
  name = "secrets_manager_role"

  inline_policy {
    name   = "policy"
    policy = data.aws_iam_policy_document.inline_policy.json
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_instance_profile" "secrets_manager_profile" {
  name = "secrets_manager_profile"
  role = aws_iam_role.secrets_manager_role.name
}
