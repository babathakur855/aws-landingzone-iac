provider "aws" {
  region = var.home_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "management"
    }
  }
}

# --------------------------------------------------------------------------
# Cross-account provider aliases for future use by AFT-provisioned modules.
# These are configured but only activated when the corresponding role ARNs
# are provided (i.e., after AFT vends the accounts).
# --------------------------------------------------------------------------
provider "aws" {
  alias  = "log_archive"
  region = var.home_region

  assume_role {
    role_arn = var.log_archive_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "log-archive"
    }
  }
}

provider "aws" {
  alias  = "audit"
  region = var.home_region

  assume_role {
    role_arn = var.audit_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "audit"
    }
  }
}

provider "aws" {
  alias  = "security"
  region = var.home_region

  assume_role {
    role_arn = var.security_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "security"
    }
  }
}

provider "aws" {
  alias  = "network"
  region = var.home_region

  assume_role {
    role_arn = var.network_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "network"
    }
  }
}

provider "aws" {
  alias  = "aft_management"
  region = var.home_region

  assume_role {
    role_arn = var.aft_management_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "aft-management"
    }
  }
}