variable "name" {
  description = "Name of the synthetics module. If null, will default to product."
  type        = string
  default     = null
}

variable "schedule" {
  description = "Schedule for how often the canary is to run and when these test runs are to stop."
  type = object({
    expression          = string
    duration_in_seconds = optional(number)
  })
  default = {
    expression = "rate(5 minutes)"
  }
}

variable "runtime_version" {
  description = "Specifies the runtime version to use for the canary. For a list of valid runtime versions, see Canary Runtime Versions."
  type        = string
  default     = "syn-nodejs-puppeteer-11.0"
}

variable "execution_role_arn" {
  description = "ARN of the IAM role to be used to run the canary."
  type        = string
  default     = null
}

variable "handler" {
  description = "Entry point to use for the source code when running the canary. This value must end with the string `.handler`."
  type        = string
  default     = "canary.handler"

  validation {
    condition     = endswith(var.handler, ".handler")
    error_message = "Handler must end with `.handler`."
  }
}

variable "delete_lambda" {
  description = "Specifies whether to also delete the Lambda functions and layers used by this canary."
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "Specifies the VPC settings of the canary."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "failure_retention_period" {
  description = "Number of days to retain data about failed runs of this canary."
  type        = number
  default     = 31

  validation {
    condition     = var.failure_retention_period >= 1 && var.failure_retention_period <= 455
    error_message = "Failure retention period must be between 1 and 455 days."
  }
}

variable "run_config" {
  description = "Configuration block for individual canary runs."
  type = object({
    timeout_in_seconds    = optional(number)
    memory_in_mb          = optional(number)
    active_tracing        = optional(bool)
    environment_variables = optional(map(string))
  })
  default = null
}

variable "canary_script_s3_location" {
  description = "Location in Amazon S3 where Synthetics stores the canary script for a canary. Conflicts with `zip_file`."
  type = object({
    bucket  = optional(string)
    key     = optional(string)
    version = optional(string)
  })
  default = {}
}

variable "zip_file" {
  description = "ZIP file that contains the script, if you input your canary script directly into the canary instead of referring to an S3 location. It can be up to 225KB. Conflicts with `canary_script_s3_location`."
  type        = string
  default     = null
}

variable "start_canary" {
  description = "Specifies whether this canary is to run after it is created."
  type        = bool
  default     = true
}

variable "success_retention_period" {
  description = "Number of days to retain data about successful runs of this canary. The valid range is 1 to 455 days."
  type        = number
  default     = 31

  validation {
    condition     = var.success_retention_period >= 1 && var.success_retention_period <= 455
    error_message = "Success retention period must be between 1 and 455 days."
  }
}

variable "artifact_config" {
  description = "Configuration for canary artifacts, including the encryption-at-rest settings for artifacts that the canary uploads to Amazon S3."
  type = object({
    s3_encryption = optional(object({
      encryption_mode = optional(string)
      kms_key_arn     = optional(string)
    }))
  })
  default = null
}

variable "force_destroy" {
  description = "Specifies whether to force destroy the bucket containing the canary artifacts. This is required when the bucket contains objects. The default value is `false`."
  type        = bool
  default     = false
}

variable "snapshot_bucket_name" {
  description = "Name of the bucket to store snapshots in. If null, will default to name."
  type        = string
  default     = null
}

variable "execution_role_name" {
  description = "Name of the execution role created by this module, if one is created. If null, will default to name."
  type        = string
  default     = null
}

variable "policy_json" {
  description = "Policy JSON. If null, default policy granting S3, logging, and XRay will be attached"
  type        = string
  default     = null
}
