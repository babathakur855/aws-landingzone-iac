# ═══════════════════════════════════════════════════════════════════
# AWS Landing Zone — Root Module Orchestration
# ═══════════════════════════════════════════════════════════════════

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  partition          = data.aws_partition.current.partition
  management_account = data.aws_caller_identity.current.account_id
  account_ids = {
    management      = var.management_account_id
    log_archive     = var.log_archive_account_id
    audit           = var.audit_account_id
    security        = var.security_account_id
    network         = var.network_account_id
    shared_services = var.shared_services_account_id
    prod            = var.prod_account_id
    staging         = var.staging_account_id
    dev             = var.dev_account_id
  }
}

# ─── 1. AWS Organizations ────────────────────────────────────────
module "aws_organizations" {
  source = "./modules/aws-organizations"

  organization_name             = var.organization_name
  aws_service_access_principals = var.aws_service_access_principals
  governed_regions              = var.governed_regions
  management_account_id         = var.management_account_id
}

# ─── 2. Control Tower ───────────────────────────────────────────
module "control_tower" {
  source = "./modules/control-tower"

  home_region            = var.home_region
  governed_regions       = var.governed_regions
  log_archive_account_id = var.log_archive_account_id
  audit_account_id       = var.audit_account_id
  organization_id        = module.aws_organizations.organization_id

  depends_on = [module.aws_organizations]
}

# ─── 3. CT Customizations (AFT) ─────────────────────────────────
module "ct_customizations" {
  source = "./modules/ct-customizations"

  ct_management_account_id  = var.management_account_id
  log_archive_account_id    = var.log_archive_account_id
  audit_account_id          = var.audit_account_id
  aft_management_account_id = var.aft_management_account_id != "" ? var.aft_management_account_id : var.management_account_id
  home_region               = var.home_region
  governed_regions          = var.governed_regions
  aft_vpc_cidr              = var.aft_vpc_cidr

  depends_on = [module.control_tower]
}

# ─── 4. IAM Identity Center ─────────────────────────────────────
module "iam_identity_center" {
  source = "./modules/iam-identity-center"

  sso_provider_name  = var.sso_provider_name
  sso_instance_arn   = var.sso_instance_arn
  identity_store_id  = var.identity_store_id
  home_region        = var.home_region
  account_ids        = local.account_ids

  depends_on = [module.control_tower]
}

# ─── 5. KMS Keys ────────────────────────────────────────────────
module "kms_keys" {
  source = "./modules/kms-keys"

  home_region                = var.home_region
  management_account_id      = var.management_account_id
  log_archive_account_id     = var.log_archive_account_id
  audit_account_id           = var.audit_account_id
  security_account_id        = var.security_account_id
  network_account_id         = var.network_account_id
  shared_services_account_id = var.shared_services_account_id
  prod_account_id            = var.prod_account_id
  staging_account_id         = var.staging_account_id
  dev_account_id             = var.dev_account_id
  organization_id            = module.aws_organizations.organization_id

  depends_on = [module.control_tower]
}

# ─── 6. Hub VPC (Network Account) ──────────────────────────────
module "hub_vpc" {
  source = "./modules/hub-vpc"

  providers = {
    aws = aws.network
  }

  vpc_cidr           = var.hub_vpc_cidr
  home_region        = var.home_region
  network_account_id = var.network_account_id
  kms_key_arn        = module.kms_keys.key_arns["cloudwatch-logs"]

  depends_on = [module.kms_keys]
}

# ─── 7. Transit Gateway ────────────────────────────────────────
module "transit_gateway" {
  source = "./modules/transit-gateway"

  providers = {
    aws = aws.network
  }

  home_region        = var.home_region
  amazon_side_asn    = var.tgw_amazon_side_asn
  hub_vpc_id         = module.hub_vpc.vpc_id
  hub_subnet_ids     = module.hub_vpc.tgw_subnet_ids
  organization_id    = module.aws_organizations.organization_id
  network_account_id = var.network_account_id

  depends_on = [module.hub_vpc]
}

# ─── 8. Spoke VPCs ──────────────────────────────────────────────
module "spoke_vpc_shared_services" {
  source = "./modules/spoke-vpc"

  providers = {
    aws = aws.shared_services
  }

  vpc_name          = "shared-services-vpc"
  vpc_cidr          = var.shared_services_vpc_cidr
  home_region       = var.home_region
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  kms_key_arn       = module.kms_keys.key_arns["cloudwatch-logs"]
  account_id        = var.shared_services_account_id
  environment       = "shared-services"

  depends_on = [module.transit_gateway]
}

module "spoke_vpc_prod" {
  source = "./modules/spoke-vpc"

  providers = {
    aws = aws.prod
  }

  vpc_name          = "prod-vpc"
  vpc_cidr          = var.prod_vpc_cidr
  home_region       = var.home_region
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  kms_key_arn       = module.kms_keys.key_arns["cloudwatch-logs"]
  account_id        = var.prod_account_id
  environment       = "prod"

  depends_on = [module.transit_gateway]
}

module "spoke_vpc_staging" {
  source = "./modules/spoke-vpc"

  providers = {
    aws = aws.staging
  }

  vpc_name          = "staging-vpc"
  vpc_cidr          = var.staging_vpc_cidr
  home_region       = var.home_region
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  kms_key_arn       = module.kms_keys.key_arns["cloudwatch-logs"]
  account_id        = var.staging_account_id
  environment       = "staging"

  depends_on = [module.transit_gateway]
}

module "spoke_vpc_dev" {
  source = "./modules/spoke-vpc"

  providers = {
    aws = aws.dev
  }

  vpc_name          = "dev-vpc"
  vpc_cidr          = var.dev_vpc_cidr
  home_region       = var.home_region
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  kms_key_arn       = module.kms_keys.key_arns["cloudwatch-logs"]
  account_id        = var.dev_account_id
  environment       = "dev"

  depends_on = [module.transit_gateway]
}

# ─── 9. Network Firewall ────────────────────────────────────────
module "network_firewall" {
  source = "./modules/network-firewall"

  providers = {
    aws = aws.network
  }

  vpc_id              = module.hub_vpc.vpc_id
  firewall_subnet_ids = module.hub_vpc.firewall_subnet_ids
  home_region         = var.home_region
  kms_key_arn         = module.kms_keys.key_arns["cloudwatch-logs"]

  depends_on = [module.hub_vpc]
}

# ─── 10. DNS Resolver ──────────────────────────────────────────
module "dns_resolver" {
  source = "./modules/dns-resolver"

  providers = {
    aws = aws.network
  }

  vpc_id           = module.hub_vpc.vpc_id
  subnet_ids       = module.hub_vpc.private_subnet_ids
  home_region      = var.home_region
  organization_id  = module.aws_organizations.organization_id

  depends_on = [module.hub_vpc]
}

# ─── 11. GuardDuty Organization ─────────────────────────────────
module "guardduty_org" {
  source = "./modules/guardduty-org"

  providers = {
    aws         = aws
    aws.security = aws.security
  }

  home_region                = var.home_region
  governed_regions           = var.governed_regions
  management_account_id      = var.management_account_id
  security_account_id        = var.security_account_id
  kms_key_arn                = module.kms_keys.key_arns["guardduty-findings"]
  organization_id            = module.aws_organizations.organization_id

  depends_on = [
    module.spoke_vpc_dev,
    module.spoke_vpc_staging,
    module.spoke_vpc_prod,
    module.spoke_vpc_shared_services,
    module.iam_identity_center
  ]
}

# ─── 12. Security Hub Organization ─────────────────────────────
module "security_hub_org" {
  source = "./modules/security-hub-org"

  providers = {
    aws         = aws
    aws.security = aws.security
  }

  home_region           = var.home_region
  governed_regions      = var.governed_regions
  security_account_id   = var.security_account_id
  kms_key_arn           = module.kms_keys.key_arns["security-hub-findings"]
  organization_id       = module.aws_organizations.organization_id

  depends_on = [module.guardduty_org]
}

# ─── 13. CloudTrail Organization ───────────────────────────────
module "cloudtrail_org" {
  source = "./modules/cloudtrail-org"

  providers = {
    aws             = aws
    aws.log_archive = aws.log_archive
  }

  home_region            = var.home_region
  organization_id        = module.aws_organizations.organization_id
  management_account_id  = var.management_account_id
  log_archive_account_id = var.log_archive_account_id
  cloudtrail_kms_key_arn = module.kms_keys.key_arns["ct-cloudtrail"]
  s3_kms_key_arn         = module.kms_keys.key_arns["s3-general"]
  cloudwatch_kms_key_arn = module.kms_keys.key_arns["cloudwatch-logs"]

  depends_on = [module.kms_keys, module.aws_organizations]
}

# ─── 14. AWS Config Organization ───────────────────────────────
module "aws_config_org" {
  source = "./modules/aws-config-org"

  providers = {
    aws             = aws
    aws.log_archive = aws.log_archive
    aws.audit       = aws.audit
  }

  home_region            = var.home_region
  governed_regions       = var.governed_regions
  organization_id        = module.aws_organizations.organization_id
  log_archive_account_id = var.log_archive_account_id
  audit_account_id       = var.audit_account_id
  config_kms_key_arn     = module.kms_keys.key_arns["ct-config"]
  s3_kms_key_arn         = module.kms_keys.key_arns["s3-general"]

  depends_on = [module.cloudtrail_org]
}

# ─── 15. SCP Policies ──────────────────────────────────────────
module "scp_policies" {
  source = "./modules/scp-policies"

  organization_root_id = module.aws_organizations.root_id
  governed_regions     = var.governed_regions
  home_region          = var.home_region
  organization_id      = module.aws_organizations.organization_id
  ou_ids               = module.aws_organizations.ou_ids

  depends_on = [module.aws_organizations]
}

# ─── 16. CloudWatch Alarms ─────────────────────────────────────
module "cloudwatch_alarms" {
  source = "./modules/cloudwatch-alarms"

  home_region              = var.home_region
  security_alert_emails    = var.security_notification_emails
  ops_alert_emails         = var.ops_notification_emails
  kms_key_arn              = module.kms_keys.key_arns["sns-topics"]
  cloudtrail_log_group     = module.cloudtrail_org.cloudwatch_log_group_name

  depends_on = [module.cloudtrail_org]
}

# ─── 17. AWS Backup ────────────────────────────────────────────
module "aws_backup" {
  source = "./modules/aws-backup"

  home_region        = var.home_region
  kms_key_arn        = module.kms_keys.key_arns["backup-vault"]
  backup_schedule    = var.backup_schedule
  retention_days     = var.backup_retention_days
  organization_id    = module.aws_organizations.organization_id

  depends_on = [module.kms_keys]
}

# ─── 18. Patch Manager ─────────────────────────────────────────
module "patch_manager" {
  source = "./modules/patch-manager"

  home_region         = var.home_region
  patch_schedule      = var.patch_schedule
  patch_approval_days = var.patch_approval_days
  notification_emails = var.ops_notification_emails
  kms_key_arn         = module.kms_keys.key_arns["sns-topics"]

  depends_on = [module.iam_identity_center]
}

# ─── 19. Cost Budgets ──────────────────────────────────────────
module "cost_budgets" {
  source = "./modules/cost-budgets"

  monthly_budget_limit = var.monthly_budget_limit
  alert_emails         = var.budget_alert_emails
  account_ids          = local.account_ids
}

# ─── 20. Account Baseline ──────────────────────────────────────
module "account_baseline" {
  source = "./modules/account-baseline"

  home_region        = var.home_region
  kms_key_arns       = module.kms_keys.key_arns
  mandatory_tags     = var.mandatory_tags
  organization_id    = module.aws_organizations.organization_id

  depends_on = [
    module.aws_config_org,
    module.cloudtrail_org,
    module.security_hub_org,
    module.guardduty_org
  ]
}