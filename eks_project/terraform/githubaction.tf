// create a IAM user for githubaction which has permissions to sts and eks 

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

// creating access keys to githubaction role to save as secret in github repository "cyderes"

resource "aws_iam_access_key" "githubaction" {
  user = aws_iam_user.githubaction.name
}

//declaring variables as these will be passed during runtime 
//  username and a personal access token to push secrets to github repo cyderes
// these are required to initialis github provider in provider.tf

variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
  sensitive   = true 
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

// pushing access key and secret key of IAM user githubaction to repository cyderes 
// stored as secret ,check cyderes -> repo settings 

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
