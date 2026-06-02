variable "name" {
  description = "Name of the app mesh. Will default to product if not defined."
  default     = null
  type        = string
}

variable "is_egress_allowed" {
  description = "Determines whether egress is allowed from the app mesh."
  default     = true
  type        = bool
}
