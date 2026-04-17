terraform {
  backend "s3" {
    bucket         = "customer-tf-state"
    key            = "landingzone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }
  required_version = ">= 1.6.0"
}