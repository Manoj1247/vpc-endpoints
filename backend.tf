terraform {
  backend "s3" {
    bucket  = "terraform-vpc-endpoints" # Adjust the bucket name
    key     = "terraform.tfstate"
    region  = "us-east-1" # Adjust the region as needed
    encrypt = true
  }
}