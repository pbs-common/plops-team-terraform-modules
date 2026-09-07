"""Constants and configuration values for the terraform modules tool."""

import os
from pathlib import Path

from rich.console import Console

console = Console()

CONFIG_FILE = "config.yaml"
CONFIG_EMPTY_FILE = "config_empty.yaml"
MODULES_DIR = Path("modules")
README_FILE = "README.md"
LOCK_FILE = "modules.lock"

# Directories and files to exclude when copying cloned terraform modules
EXCLUDED_MODULE_NAMES = {
    # directories
    "examples",
    "example",
    "tests",
    "test",
    ".github",
    "docs",
    "scripts",
    # files
    "LICENSE",
    "README-HEADER.md",
    "go.mod",
    "go.sum",
    ".default-golang-pkgs",
    ".golang-pkgs",
    # tooling / meta files
    ".terraform.lock.hcl",
    ".terraform-docs.yml",
    ".tflint.hcl",
    ".tool-versions",
    ".gitignore",
}

# File suffixes to exclude when copying cloned terraform modules
EXCLUDED_MODULE_SUFFIXES = {
    ".go",
}

# GitHub API configuration
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
GITHUB_API_URL = "https://api.github.com/graphql"
GITHUB_REST_API = "https://api.github.com"
ORG_NAME = "pbs-common"

# Resource to module mapping
# Maps AWS resource types to their corresponding terraform module names
RESOURCE_TO_MODULE_MAP = {
    # S3 resources
    "aws_s3_bucket": "terraform-aws-s3-module",
    "aws_s3_bucket_public_access_block": "terraform-aws-s3-module",
    "aws_s3_bucket_versioning": "terraform-aws-s3-module",
    "aws_s3_bucket_acl": "terraform-aws-s3-module",
    "aws_s3_bucket_cors_configuration": "terraform-aws-s3-module",
    "aws_s3_bucket_lifecycle_configuration": "terraform-aws-s3-module",
    "aws_s3_bucket_server_side_encryption_configuration": "terraform-aws-s3-module",
    "aws_s3_bucket_inventory": "terraform-aws-s3-module",
    "aws_s3_bucket_ownership_controls": "terraform-aws-s3-module",
    "aws_s3_bucket_replication_configuration": "terraform-aws-s3-module",
    "aws_s3_object": "terraform-aws-s3-module",

    # S3 Bucket Policy resources
    "aws_s3_bucket_policy": "terraform-aws-s3-bucket-policy-module",

    # S3 Bucket Notification resources
    "aws_s3_bucket_notification": "terraform-aws-bucket-notification-module",

    # Lambda resources
    "aws_lambda_function": "terraform-aws-lambda-module",
    "aws_lambda_permission": "terraform-aws-lambda-module",
    "aws_lambda_event_source_mapping": "terraform-aws-lambda-module",
    "aws_lambda_alias": "terraform-aws-lambda-module",
    "aws_lambda_layer_version": "terraform-aws-lambda-module",

    # RDS resources
    "aws_db_instance": "terraform-aws-rds-module",
    "aws_db_subnet_group": "terraform-aws-rds-module",
    "aws_db_parameter_group": "terraform-aws-rds-module",
    "aws_rds_cluster": "terraform-aws-rds-module",
    "aws_rds_cluster_instance": "terraform-aws-rds-module",
    "aws_rds_cluster_parameter_group": "terraform-aws-rds-module",
    "aws_db_option_group": "terraform-aws-rds-module",
    "aws_db_proxy": "terraform-aws-rds-module",
    "aws_db_proxy_default_target_group": "terraform-aws-rds-module",
    "aws_db_proxy_endpoint": "terraform-aws-rds-module",
    "aws_db_proxy_target": "terraform-aws-rds-module",
    "aws_secretsmanager_secret": "terraform-aws-rds-module",
    "aws_secretsmanager_secret_version": "terraform-aws-rds-module",

    # ECS Cluster resources
    "aws_ecs_cluster": "terraform-aws-ecs-cluster-module",
    "aws_ecs_cluster_capacity_providers": "terraform-aws-ecs-cluster-module",
    "aws_ecs_capacity_provider": "terraform-aws-ecs-cluster-module",
    "aws_launch_template": "terraform-aws-ecs-cluster-module",
    "aws_autoscaling_group": "terraform-aws-ecs-cluster-module",

    # ECS Service resources
    "aws_ecs_service": "terraform-aws-ecs-service-module",
    "aws_lb": "terraform-aws-ecs-service-module",
    "aws_alb": "terraform-aws-ecs-service-module",
    "aws_lb_target_group": "terraform-aws-ecs-service-module",
    "aws_alb_target_group": "terraform-aws-ecs-service-module",
    "aws_lb_listener": "terraform-aws-ecs-service-module",
    "aws_alb_listener": "terraform-aws-ecs-service-module",
    "aws_lb_listener_rule": "terraform-aws-ecs-service-module",
    "aws_alb_listener_rule": "terraform-aws-ecs-service-module",
    "aws_appautoscaling_target": "terraform-aws-ecs-service-module",
    "aws_appautoscaling_policy": "terraform-aws-ecs-service-module",
    "aws_appautoscaling_scheduled_action": "terraform-aws-ecs-service-module",
    "aws_eip": "terraform-aws-ecs-service-module",
    "aws_service_discovery_service": "terraform-aws-ecs-service-module",

    # ECS Task Definition resources
    "aws_ecs_task_definition": "terraform-aws-ecs-task-definition-module",

    # CloudFront resources
    "aws_cloudfront_distribution": "terraform-aws-cloudfront-module",
    "aws_cloudfront_cache_policy": "terraform-aws-cloudfront-cache-policy-module",
    "aws_cloudfront_origin_request_policy": "terraform-aws-cloudfront-origin-request-policy-module",
    "aws_cloudfront_response_headers_policy": "terraform-aws-cloudfront-response-headers-policy-module",
    "aws_cloudfront_function": "terraform-aws-cloudfront-function-module",
    "aws_cloudfront_origin_access_identity": "terraform-aws-cloudfront-module",
    "aws_cloudfront_origin_access_control": "terraform-aws-cloudfront-module",
    "aws_cloudwatch_log_delivery": "terraform-aws-cloudfront-module",
    "aws_cloudwatch_log_delivery_destination": "terraform-aws-cloudfront-module",
    "aws_cloudwatch_log_delivery_source": "terraform-aws-cloudfront-module",

    # IAM resources
    "aws_iam_role": "terraform-aws-iam-role-module",
    "aws_iam_policy": "terraform-aws-iam-role-module",
    "aws_iam_role_policy": "terraform-aws-iam-role-module",
    "aws_iam_role_policy_attachment": "terraform-aws-iam-role-module",
    "aws_iam_policy_attachment": "terraform-aws-iam-role-module",
    "aws_iam_instance_profile": "terraform-aws-iam-role-module",

    # SNS resources
    "aws_sns_topic": "terraform-aws-sns-topic-module",
    "aws_sns_topic_policy": "terraform-aws-sns-topic-module",
    "aws_sns_topic_subscription": "terraform-aws-sns-topic-subscription-module",

    # DynamoDB resources
    "aws_dynamodb_table": "terraform-aws-dynamodb-module",
    "aws_dynamodb_table_item": "terraform-aws-dynamodb-module",

    # ECR resources
    "aws_ecr_repository": "terraform-aws-ecr-module",
    "aws_ecr_repository_policy": "terraform-aws-ecr-module",
    "aws_ecr_lifecycle_policy": "terraform-aws-ecr-module",

    # CloudWatch resources
    "aws_cloudwatch_log_group": "terraform-aws-cloudwatch-alarms-module",
    "aws_cloudwatch_log_stream": "terraform-aws-cloudwatch-alarms-module",
    "aws_cloudwatch_log_metric_filter": "terraform-aws-cloudwatch-alarms-module",
    "aws_cloudwatch_metric_alarm": "terraform-aws-cloudwatch-alarms-module",
    "aws_cloudwatch_event_rule": "terraform-aws-cloudwatch-event-rule-module",
    "aws_cloudwatch_event_target": "terraform-aws-cloudwatch-event-rule-module",

    # ElastiCache resources
    "aws_elasticache_cluster": "terraform-aws-elasticache-memcached-module",
    "aws_elasticache_replication_group": "terraform-aws-elasticache-redis-standalone-module",
    "aws_elasticache_subnet_group": "terraform-aws-elasticache-memcached-module",
    "aws_elasticache_parameter_group": "terraform-aws-elasticache-parameter-group-module",
    "aws_elasticache_serverless_cache": "terraform-aws-elasticache-serverless-redis-and-memcached-module",

    # EFS resources
    "aws_efs_file_system": "terraform-aws-efs-module",
    "aws_efs_mount_target": "terraform-aws-efs-module",
    "aws_efs_access_point": "terraform-aws-efs-module",
    "aws_efs_backup_policy": "terraform-aws-efs-module",

    # Security Group resources
    "aws_security_group": "terraform-aws-sg-rule-module",  # TODO: Module only handles rules, not groups
    "aws_security_group_rule": "terraform-aws-sg-rule-module",
    "aws_vpc_security_group_ingress_rule": "terraform-aws-sg-rule-module",
    "aws_vpc_security_group_egress_rule": "terraform-aws-sg-rule-module",

    # CloudWatch Synthetics resources
    "aws_synthetics_canary": "terraform-aws-synthetics-module",

    # WAFv2 resources
    "aws_wafv2_ip_set": "terraform-aws-wafv2-rule-group-module",
    "aws_wafv2_regex_pattern_set": "terraform-aws-wafv2-rule-group-module",
    "aws_wafv2_rule_group": "terraform-aws-wafv2-rule-group-module",

    # Amplify resources
    "aws_amplify_app": "terraform-aws-amplify-module",
    "aws_amplify_backend_environment": "terraform-aws-amplify-module",
    "aws_amplify_branch": "terraform-aws-amplify-module",
    "aws_amplify_domain_association": "terraform-aws-amplify-module",
    "aws_amplify_webhook": "terraform-aws-amplify-module",

    # Lambda API (API Gateway v2) resources
    "aws_apigatewayv2_api": "terraform-aws-lambda-api-module",
    "aws_apigatewayv2_api_mapping": "terraform-aws-lambda-api-module",
    "aws_apigatewayv2_domain_name": "terraform-aws-lambda-api-module",
    "aws_apigatewayv2_integration": "terraform-aws-lambda-api-module",
    "aws_apigatewayv2_route": "terraform-aws-lambda-api-module",
    "aws_apigatewayv2_stage": "terraform-aws-lambda-api-module",

    # Lambda LB resources
    "aws_lb_target_group_attachment": "terraform-aws-lambda-lb-module",

    # Application Insights resources
    "aws_applicationinsights_application": "terraform-aws-application-insights-module",

    # App Mesh resources
    "aws_appmesh_mesh": "terraform-aws-app-mesh-module",
    "aws_appmesh_virtual_gateway": "terraform-aws-virtual-gateway-module",
    "aws_appmesh_virtual_router": "terraform-aws-virtual-router-module",
    "aws_appmesh_virtual_service": "terraform-aws-virtual-service-module",

    # Service Discovery namespace resources
    "aws_service_discovery_http_namespace": "terraform-aws-namespace-module",
    "aws_service_discovery_private_dns_namespace": "terraform-aws-namespace-module",
    "aws_service_discovery_public_dns_namespace": "terraform-aws-namespace-module",

    # FMS resources
    "aws_fms_policy": "terraform-aws-fms-policy-module",

    # Resource Group resources
    "aws_resourcegroups_group": "terraform-aws-resource-group-module",

    # SQS resources
    "aws_sqs_queue": "terraform-aws-sqs-module",
    "aws_sqs_queue_redrive_allow_policy": "terraform-aws-sqs-module",
}

# README markers
README_MODULES_SECTION = "## Modules"
README_START_MARKER = "<!--"
README_END_MARKER = "-->"
README_GENERATED_COMMENT = """<!--
This section is automatically updated by running:

    ./scripts/tfmodules.py readme

Do not edit manually.
-->"""
