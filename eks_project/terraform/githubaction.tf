resource "aws_iam_user" "githubaction" {
  name = "githubaction"
}

resource "aws_iam_policy" "github_action" {
  name   = "github-action"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["eks:DescribeCluster", "sts:GetCallerIdentity"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.githubaction.name
  policy_arn = aws_iam_policy.github_action.arn
}


resource "aws_iam_access_key" "githubaction" {
  user = aws_iam_user.githubaction.name
}

variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
  sensitive   = true 
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}


resource "github_actions_secret" "aws_access_key_id" {
  repository = "cyderes"
  secret_name = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.githubaction.id
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository = "cyderes"
  secret_name = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.githubaction.secret
}
