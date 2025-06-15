variable "cluster_name" {
  default = "eks-free-tier"
}

variable "node_group_name" {
  default = "eks_node_group"
}


variable "instance_type" {
  default = "t3.micro"  // Free Tier instance type for worker nodes
}

