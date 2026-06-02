# Even though taking snapshots is optional, a bucket will always be created
# so that there's a place to put the snapshots if they are enabled.
module "s3" {
  source = "github.com/pbs/terraform-aws-s3-module?ref=5.0.0"

  name = local.snapshot_bucket_name

  force_destroy = var.force_destroy

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
