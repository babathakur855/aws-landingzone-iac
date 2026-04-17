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
  alias  = "shared_services"
  region = var.home_region

  assume_role {
    role_arn = var.shared_services_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "shared-services"
    }
  }
}

provider "aws" {
  alias  = "prod"
  region = var.home_region

  assume_role {
    role_arn = var.prod_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "prod"
    }
  }
}

provider "aws" {
  alias  = "staging"
  region = var.home_region

  assume_role {
    role_arn = var.staging_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "staging"
    }
  }
}

provider "aws" {
  alias  = "dev"
  region = var.home_region

  assume_role {
    role_arn = var.dev_role_arn
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "AWS-Landing-Zone"
      Environment = "dev"
    }
  }
}