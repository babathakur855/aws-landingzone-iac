terraform {
  # Backend intentionally configured for local state initially.
  # After bootstrapping the S3 bucket and DynamoDB table via AFT or manually,
  # uncomment and migrate state with `terraform init -migrate-state`.
  #
  # backend "s3" {
  #   bucket         = "REPLACE-WITH-STATE-BUCKET"
  #   key            = "landingzone/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "REPLACE-WITH-LOCK-TABLE"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  required_version = ">= 1.6.0"
}