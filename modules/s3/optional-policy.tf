variable "bucket_policy" {
  description = "Policy to apply to the bucket. If null, one will be guessed based on other variables."
  default     = null
  type        = string
}

variable "force_tls" {
  description = "Deny HTTP requests that are made to the bucket without TLS."
  default     = true
  type        = bool
}

variable "replication_source" {
  description = "The account number and role for the source bucket in a replication configuration."
  default     = null
  type = object({
    account_id = string
    role       = string
  })
}

variable "allow_anonymous_vpce_access" {
  description = "Create bucket policy that allows anonymous VPCE access."
  default     = false
  type        = bool
}

variable "vpce" {
  description = "Name of the VPC endpoint that should have access to this bucket. Only used when `allow_anonymous_vpce_access` is true."
  default     = null
  type        = string
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements defined in source_policy_documents or source_json must have unique sids. Statements with the same sid from documents assigned to the override_json and override_policy_documents arguments will override source statements."
  default     = null
  type        = list(string)
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank sids will override statements with the same sid from earlier documents in the list. Statements with non-blank sids will also override statements with the same sid from documents provided in the source_json and source_policy_documents arguments. Non-overriding statements will be added to the exported document."
  default     = null
  type        = list(string)
}

variable "cloudfront_oac_access_statements" {
  description = "List of objects that define the CloudFront origin access identity access statement. Each object must have a `cloudfront_arn` and `path` key."
  default     = []
  type = list(object({
    cloudfront_arn = string
    path           = optional(string, "*")
  }))
}
