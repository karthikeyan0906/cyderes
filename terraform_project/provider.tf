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


