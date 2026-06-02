variable "name" {
  description = "Name of the SNS Topic"
  default     = null
  type        = string
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic."
  default     = false
  type        = bool
}

variable "create_topic_policy" {
  description = "Whether to create an SNS topic access policy. When true, a default policy allowing all SNS actions is created unless topic_policy is provided."
  default     = false
  type        = bool
}

variable "topic_policy" {
  description = "JSON policy document for the SNS topic. Overrides the default policy when provided. Only used when create_topic_policy is true."
  default     = null
  type        = string
}
