locals {
  name = var.name != null ? var.name : var.product

  source_code_hash = try(filebase64sha256(var.filename), null)

  ssm_path         = var.ssm_path != null ? var.ssm_path : "/${var.environment}/${local.name}"
  environment_vars = var.environment_vars != null ? var.environment_vars : { "SSM_PATH" = local.ssm_path }
  environment_map  = length(local.environment_vars) == 0 ? toset([]) : toset([local.environment_vars])

  default_lambda_insights_extension_version_x86        = "21"
  default_lambda_insights_extension_version_arm        = "2"
  default_parameters_and_secrets_extension_version_arm = "2"
  default_parameters_and_secrets_extension_version_x86 = "2"
  default_app_config_extension_version_x86             = "82"
  default_app_config_extension_version_arm             = "15"

  lambda_insights_extension_version = var.lambda_insights_extension_version != null ? var.lambda_insights_extension_version : var.architectures == tolist(["arm64"]) ? local.default_lambda_insights_extension_version_arm : local.default_lambda_insights_extension_version_x86
  lambda_insights_extension_name    = var.architectures == tolist(["arm64"]) ? "LambdaInsightsExtension-Arm64" : "LambdaInsightsExtension"

  app_config_extension_version = var.app_config_extension_version != null ? var.app_config_extension_version : var.architectures == tolist(["arm64"]) ? local.default_app_config_extension_version_arm : local.default_app_config_extension_version_x86
  app_config_extension_name    = var.architectures == tolist(["arm64"]) ? "AWS-AppConfig-Extension-Arm64" : "AWS-AppConfig-Extension"

  parameters_and_secrets_extension_version = var.parameters_and_secrets_extension_version != null ? var.parameters_and_secrets_extension_version : var.architectures == tolist(["arm64"]) ? local.default_parameters_and_secrets_extension_version_arm : local.default_parameters_and_secrets_extension_version_x86
  parameters_and_secrets_extension_name    = var.architectures == tolist(["arm64"]) ? "AWS-Parameters-and-Secrets-Lambda-Extension-Arm64" : "AWS-Parameters-and-Secrets-Lambda-Extension"

  # Layers aren't supported for Docker images.
  default_layers = var.image_uri != null ? [] : compact([
    "arn:aws:lambda:${data.aws_region.current.region}:${var.lambda_insights_extension_account_number}:layer:${local.lambda_insights_extension_name}:${local.lambda_insights_extension_version}",
    var.add_ssm_extension_layer ? "arn:aws:lambda:${data.aws_region.current.region}:${var.parameters_and_secrets_extension_account_number}:layer:${local.parameters_and_secrets_extension_name}:${local.parameters_and_secrets_extension_version}" : "",
    var.add_app_config_extension_layer ? "arn:aws:lambda:${data.aws_region.current.region}:${var.app_config_extension_account_number}:layer:${local.app_config_extension_name}:${local.app_config_extension_version}" : "",
  ])

  layers                = var.layers != null ? var.layers : local.default_layers
  description           = var.description != null ? var.description : "${local.name} function"
  policy_json           = var.policy_json != null ? var.policy_json : data.aws_iam_policy_document.default_policy_document[0].json
  role                  = var.role_arn != null ? var.role_arn : module.default_role[0].arn
  vpc_id                = var.vpc_id != null ? var.vpc_id : var.add_vpc_config ? data.aws_vpc.vpc[0].id : null
  create_security_group = var.add_vpc_config && var.security_group_id == null
  subnet_ids            = var.subnets != null ? var.subnets : var.add_vpc_config ? flatten([for subnet in data.aws_subnets.private_subnets : subnet.ids]) : []
  security_group_id     = local.create_security_group ? aws_security_group.sg[0].id : var.security_group_id
  log_group_name        = "/aws/lambda/${local.name}"

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:owner"       = var.owner
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
