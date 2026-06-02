variable "name" {
  description = "Name of the IAM role. If use_prefix is true, this will be the prefix of the role name. If null, will default to `product` value."
  default     = null
  type        = string
}

variable "use_prefix" {
  description = "Use prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "aws_services" {
  description = "AWS services that will be assuming this role. e.g. [lambda, edgelambda]"
  type        = set(string)
  default     = []
}


variable "assume_role_policy" {
  description = "JSON string of the assume role policy. If null, assumes that aws_services have been provided."
  default     = null
  type        = string
}

variable "create_instance_profile" {
  description = "Create an instance profile for this role"
  default     = false
  type        = bool
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary to use for this role"
  default     = null
  type        = string
}

variable "path" {
  description = "Path to the role"
  default     = null
  type        = string
}
