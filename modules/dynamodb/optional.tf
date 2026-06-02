variable "name" {
  description = "Name for the table"
  default     = null
  type        = string
}

variable "hash_key" {
  description = "DynamoDB Table Hash Key"
  default = {
    name = "id"
    type = "S"
  }
  type = map(any)
}

variable "range_key" {
  description = "DynamoDB Table Range Key"
  default     = null
  type        = map(any)
}

variable "global_secondary_indices" {
  description = "Map of global secondary indices"
  default     = {}
  type        = map(any)
}

variable "local_secondary_indices" {
  description = "Map of local secondary indices"
  default     = {}
  type        = map(any)
}

variable "additional_attributes" {
  description = "List of map of additional attributes. Necessary for global secondary indices"
  default     = []
  type        = list(map(any))
}

variable "billing_mode" {
  description = "Billing mode for table"
  default     = "PAY_PER_REQUEST"
  type        = string
}

variable "min_capacity" {
  description = "Minimum capacity for the database"
  default     = 5
  type        = number
}

variable "max_capacity" {
  description = "Maximum capacity for the database"
  default     = 20
  type        = number
}

variable "prod_min_capacity" {
  description = "Minimum capacity for the production database. Defaults to min_capacity"
  default     = null
  type        = number
}

variable "prod_max_capacity" {
  description = "Maximum capacity for the production database. Defaults to max_capacity"
  default     = null
  type        = number
}

variable "target_value" {
  description = "Target value for the metric"
  default     = 70
  type        = number
}

variable "ttl" {
  description = "Attribute to use for TTL. If null, will not use ttl"
  default     = null
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Enable point in time recovery"
  default     = true
  type        = bool
}
