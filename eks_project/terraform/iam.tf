resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

// Attaching IAM Roles

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  for_each = toset([ // passing the policy as sets to have unqique values
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" //sandbox bootstapping failed without this permission  
  ])

  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.key
}

//cluster role creation for githubaction user for helm deployment

resource "kubernetes_cluster_role" "helm_deployer" {
  metadata {
    name = "helm-deployer"
  }

# Core resources (including secrets)
rule {
  api_groups = [""]
  resources  = ["pods", "services", "secrets"]
  verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
}

# apps and batch workloads
rule {
  api_groups = ["apps", "batch"]
  resources  = ["deployments", "replicasets", "jobs"]
  verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
}

}

resource "kubernetes_cluster_role_binding" "helm_deployer_binding" {
  metadata {
    name = "helm-deployer-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.helm_deployer.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "deployers"  // update this group in aws-auth for github action user
    api_group = "rbac.authorization.k8s.io"
  }
}
