variable "name" {
  description = "Name to use for the bucket. If null, will default to product."
  default     = null
  type        = string
}

variable "use_prefix" {
  description = "Create bucket with prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "is_versioned" {
  description = "Is versioning enabled?"
  default     = true
  type        = bool
}

variable "acl" {
  description = "ACL configuration for the bucket. If an ACL is not provided, the bucket will be created with ACLs disabled"
  default     = null
  type = object({
    canned_acl            = optional(string)
    expected_bucket_owner = optional(string)
    access_control_policy = optional(object({
      grants = set(object({
        grantee = object({
          type          = string
          email_address = optional(string)
          id            = optional(string)
          uri           = optional(string)
        })
        permission = string
      }))
      owner = object({
        id           = string
        display_name = optional(string)
      })
    }))
  })
  validation {
    condition     = var.acl == null || !(try(var.acl.canned_acl, null) != null && try(var.acl.access_control_policy, null) != null)
    error_message = "Only one of canned_acl or access_control_policy can be set"
  }
}

variable "force_destroy" {
  description = "Allow destruction of an S3 bucket without clearing out the contents first"
  default     = false
  type        = bool
}

variable "cors_rules" {
  description = "CORS Rules"
  default     = []
  type = set(object({
    allowed_headers = list(string),
    allowed_methods = list(string),
    allowed_origins = list(string),
    expose_headers  = list(string),
    max_age_seconds = number
  }))
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type = list(object({
    id      = string
    enabled = optional(bool, true)
    filter = optional(object({
      and = optional(list(object({
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        prefix                   = optional(string)
        tags                     = optional(map(string))
      })))
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      prefix                   = optional(string)
      tag = optional(object({
        key   = string
        value = string
      }))
    }), {})
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    noncurrent_version_expiration = optional(object({
      days = optional(number)
    }))
    noncurrent_version_transition = optional(list(object({
      days          = optional(number)
      storage_class = optional(string)
    })), [])
    transition = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })), [])
  }))
  default = [{
    id                                     = "default-lifecycle-rule",
    enabled                                = true,
    abort_incomplete_multipart_upload_days = 7,

    transition = [
      {
        days          = 7,
        storage_class = "INTELLIGENT_TIERING",
      }
    ]

    noncurrent_version_transition = [
      {
        days          = 30,
        storage_class = "GLACIER",
      }
    ]
  }]

  # Example:
  #
  # lifecycle_rules = [
  #   {
  #     id      = "log"
  #     enabled = true
  #
  #     prefix = "log/"
  #
  #     tags = {
  #       "rule"      = "log"
  #       "autoclean" = "true"
  #     }
  #
  #     transition = [
  #       {
  #         days          = 30
  #         storage_class = "STANDARD_IA" # or "ONEZONE_IA"
  #       },
  #       {
  #         days          = 60
  #         storage_class = "GLACIER"
  #       }
  #     ]
  #
  #     expiration = {
  #       days = 90
  #     }
  #   }
  # ]
}

variable "replication_configuration_set" {
  description = "Set of (single) replication that needs to be managed by this bucket. If empty, no replication takes place."
  default     = []
  type = set(object({
    role = string,
    rules = set(object({
      id                                           = string
      priority                                     = number
      status                                       = string
      destination_account_id                       = string
      destination_bucket                           = string
      destination_access_control_translation_owner = string
    }))
  }))
}

variable "replication_configuration_shortcut" {
  description = "Shorthand version of the configuration used in replication_configuration_set. Is overridden by replication_configuration_set if defined."
  default     = null
  type = object({
    destination_account_id = string
    destination_bucket     = string
  })
}

variable "create_bucket_policy" {
  description = "Create a bucket policy for the bucket"
  default     = true
  type        = bool
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
  type        = bool
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
  type        = bool
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = true
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
  type        = bool
}

variable "inventory_config" {
  description = "Inventory configuration"
  default     = null
  type = object({
    enabled = optional(bool, true)

    included_object_versions = optional(string, "All")
    destination = object({
      bucket = object({
        name       = string
        format     = optional(string, "Parquet")
        prefix     = optional(string)
        account_id = optional(string)
      })
    })
    filter = optional(object({
      prefix = string
    }))
    schedule = optional(object({
      frequency = string
      }), {
      frequency = "Daily"
    })
    optional_fields = optional(list(string), [
      "Size",
      "LastModifiedDate",
      "StorageClass",
      "IntelligentTieringAccessTier",
    ])
  })
}
