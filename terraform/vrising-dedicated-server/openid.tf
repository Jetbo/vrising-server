
data "external" "github_thumbprint" {
  program = [
    "/bin/bash",
    "${path.module}/scripts/get_github_thumbprint.bash"
  ]
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    data.external.github_thumbprint.result.thumbprint,
  ]
}

resource "aws_iam_policy" "github_openid" {
  name        = "github-openid"
  description = "Github OIDC that allows ECR management"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeImageScanFindings",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetRepositoryPolicy",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:PutImageScanningConfiguration",
          "ecr:PutImageTagMutability",
          "ecr:PutLifecyclePolicy",
          "ecr:ReplicateImage",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:UploadLayerPart"
        ],
        Resource = "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/dedicated-server/*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "github_openid" {
  name        = "github-openid"
  description = "Github OIDC federated role"
  assume_role_policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { "Federated" : aws_iam_openid_connect_provider.github.arn },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : var.openid_github_repo
          },
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_openid_attach_1" {
  role       = aws_iam_role.github_openid.name
  policy_arn = aws_iam_policy.github_openid.arn
}
