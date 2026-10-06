terraform {
  backend "s3" {
    bucket       = "gk-terraform-state-ap-south-1"
    key          = "path/to/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}