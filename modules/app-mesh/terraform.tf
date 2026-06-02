terraform {
  required_version = ">= 1.13.0"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      version = ">= 6.0.0"
    }
  }
}

