variable "name" {
  description = "Name of the namespace. If null, will default to product."
  default     = null
  type        = string
}

variable "type" {
  description = "Type of the namespace."
  default     = "http"
  type        = string
}

variable "description" {
  description = "Description of the namespace. If null, will default to `{name} namespace`."
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for a private namespace. If null, will be looked up based on the environment parameter."
  default     = null
  type        = string
}
