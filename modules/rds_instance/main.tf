locals {

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${try(random_id.snapshot_identifier[0].hex, "")}"

  identifier        = var.use_identifier_prefix ? null : var.identifier
  identifier_prefix = var.use_identifier_prefix ? "${var.identifier}-" : null

  # Replicas will use source metadata
  is_replica = var.replicate_source_db != null
}

data "aws_rds_certificate" "cert" {
  latest_valid_till = true
}

resource "random_id" "snapshot_identifier" {
  count = !var.skip_final_snapshot ? 1 : 0

  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

resource "aws_db_instance" "this" {
  identifier        = local.identifier
  identifier_prefix = local.identifier_prefix

  engine            = local.is_replica ? null : var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = local.is_replica ? null : var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model

  db_name                             = var.db_name
  username                            = !local.is_replica ? var.username : null
  password                            = !local.is_replica && var.manage_master_user_password ? null : var.password
  port                                = var.port
  domain                              = var.domain
  domain_iam_role_name                = var.domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile
  manage_master_user_password         = !local.is_replica && var.manage_master_user_password ? var.manage_master_user_password : null
  master_user_secret_kms_key_id       = !local.is_replica && var.manage_master_user_password ? var.master_user_secret_kms_key_id : null

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.parameter_group_name
  option_group_name      = var.option_group_name
  network_type           = var.network_type

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  storage_throughput  = var.storage_throughput
  publicly_accessible = var.publicly_accessible
  ca_cert_identifier  = var.ca_cert_identifier == null ? data.aws_rds_certificate.cert.id : var.ca_cert_identifier

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html
  dynamic "blue_green_update" {
    for_each = length(var.blue_green_update) > 0 ? [var.blue_green_update] : []

    content {
      enabled = try(blue_green_update.value.enabled, null)
    }
  }

  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = local.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = length(var.blue_green_update) > 0 ? coalesce(var.backup_retention_period, 1) : var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  character_set_name              = var.character_set_name
  nchar_character_set_name        = var.nchar_character_set_name
  timezone                        = var.timezone
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }

  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = "mysql"
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }

  tags = merge(var.tags, var.rds_tags)

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  # Note: do not add `latest_restorable_time` to `ignore_changes`
  # https://github.com/terraform-aws-modules/terraform-aws-rds/issues/478
}

# ################################################################################
# # IAM resources
# ################################################################################

locals {
  oidc_provider        = coalesce(var.oidc_provider, "none")
  kubernetes_namespace = coalesce(var.kubernetes_namespace, "none")
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "discovery" {
  statement {
    sid       = "DiscoverInstances"
    effect    = "Allow"
    resources = ["arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:*"]
    actions   = ["rds:DescribeDBInstances"]
  }
  statement {
    sid       = "DiscoverProxies"
    effect    = "Allow"
    resources = ["arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db-proxy:*"]
    actions   = ["rds:DescribeDBProxies"]
  }
}

data "aws_iam_policy_document" "connect" {
  statement {
    sid       = "Connect"
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.this.id}/*"]
    actions   = ["rds-db:connect"]
  }
}

data "aws_iam_policy_document" "secretsmanager" {
  statement {
    sid       = "DecryptSecrets"
    effect    = "Allow"
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"]
    actions   = ["kms:Decrypt"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
    }
  }

  statement {
    sid       = "ListSecrets"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:GetRandomPassword",
    ]
  }

  statement {
    sid       = "GetSecrets"
    effect    = "Allow"
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:rds!db-*"]

    actions = [
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret",
    ]
  }
}

data "aws_iam_policy_document" "kubernetes" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:${local.kubernetes_namespace}:*"]
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"]
    }
  }
}

data "aws_iam_policy_document" "services" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "discovery" {
  name   = "${aws_db_instance.this.identifier}-discovery"
  policy = data.aws_iam_policy_document.discovery.json
}

resource "aws_iam_policy" "connect" {
  name   = "${aws_db_instance.this.identifier}-connect"
  policy = data.aws_iam_policy_document.connect.json
}

resource "aws_iam_policy" "secretsmanager" {
  name   = "${aws_db_instance.this.identifier}-secretsmanager-read"
  policy = data.aws_iam_policy_document.secretsmanager.json
}

resource "aws_iam_role" "access_from_kubernetes" {
  count               = local.kubernetes_namespace == "none" || local.oidc_provider == "none" ? 0 : 1
  name                = "${aws_db_instance.this.identifier}-for-kubernetes"
  assume_role_policy  = data.aws_iam_policy_document.kubernetes.json
  managed_policy_arns = [aws_iam_policy.connect.arn, aws_iam_policy.secretsmanager.arn, aws_iam_policy.discovery.arn]
}

resource "aws_iam_role" "access_from_aws" {
  name                = "${aws_db_instance.this.identifier}-for-aws-services"
  assume_role_policy  = data.aws_iam_policy_document.services.json
  managed_policy_arns = [aws_iam_policy.connect.arn, aws_iam_policy.secretsmanager.arn]
  tags                = var.tags
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${aws_db_instance.this.identifier}-for-ec2"
  role = aws_iam_role.access_from_aws.name
}
