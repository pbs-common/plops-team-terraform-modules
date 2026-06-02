variable "name" {
  description = "Name of the EFS file system. If null, will default to product."
  default     = null
  type        = string
}

variable "is_encrypted" {
  description = "Boolean indicating if the EFS should be encrypted or not. Default is true"
  default     = true
  type        = bool
}

variable "kms_key_id" {
  description = "The ID for the KMS key to use for encryption."
  default     = null
  type        = string
}

#Default is AFTER_30_DAYS to try to get some cost savings.
variable "lifecycle_policy" {
  description = "The lifecycle policy to use for transition EFS objects to infrequent access (IA) storage. Default: AFTER_30_DAYS. Valid values: NONE, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS."
  type        = string
  default     = "AFTER_30_DAYS"
}

variable "performance_mode" {
  description = "The performance mode for the EFS. Can be either generalPurpose or maxIO. Default is generalPurpose"
  type        = string
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  description = "Setting this variable changes the EFS performance mode from bursting to provisioned, and sets the provisioned_throughput_in_mibps setting for the EFS. If 0, the performance mode will be bursting."
  type        = string
  default     = 0
}

variable "subnets" {
  description = "A list of subnet IDs where the app will be mounted. Must all be from the same VPC"
  type        = list(any)
  default     = null
}

variable "security_groups" {
  description = "A list of security group IDs that will be applied to the EFS managing access."
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  description = "The ID of the VPC to build the EFS in."
  type        = string
  default     = null
}

variable "creation_token" {
  description = "The creation token used for the EFS file system"
  type        = string
  default     = null
}

variable "backup_policy" {
  description = "The backup policy to use for the EFS file system. Valid values: ENABLED, DISABLED."
  type        = string
  default     = "ENABLED"
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.backup_policy)
    error_message = "The backup_policy variable must be either ENABLED or DISABLED."
  }
}
