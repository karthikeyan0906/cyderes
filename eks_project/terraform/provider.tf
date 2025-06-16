terraform {
  required_version = ">= 1.12.1" // old TF version doesnt support s3 for statelocking and requires dynamodb 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1" // recent stable version from terraform 
    }
  }
}

provider "aws" {
  region  = "ap-south-1" // using mumbai for my free tier AWS account 
}

provider "github" {
  token = var.github_token  #pass this as env variable with TF_VAR_github_token as prefix
  owner = var.github_username #pass this as env variable with appropriate prefix
}

provider "kubernetes" {
  config_path = "~/.kube/config"  #kube config from default location is picked for provider
}