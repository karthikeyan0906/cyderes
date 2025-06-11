terraform {
  backend "s3" {
    bucket        = "terraform-state-059006397579" // using account ID as we need to have unique bucket names across AWS 
    key           = "terraform.tfstate"
    region        = "ap-south-1"
    encrypt       = true
    use_lockfile  = true  // used for s3 state locking since we use terraform 1.12.1
  }
}
