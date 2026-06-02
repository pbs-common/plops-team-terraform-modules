variable "type" {
  description = "The type of rule to create. Valid values are egress, ingress, and all."
  type        = string
  default     = "ingress"
}

variable "port" {
  description = "The port to allow."
  type        = number
  default     = null
}

variable "from_port" {
  description = "The start port"
  type        = number
  default     = null
}

variable "to_port" {
  description = "The end port"
  type        = number
  default     = null
}

variable "protocol" {
  description = "The protocol to allow. Valid values are tcp, udp, and all."
  type        = string
  default     = "tcp"
}

variable "source_security_group_id" {
  description = "The ID of the security group that is allowed access."
  type        = string
  default     = null
}

variable "source_cidr_blocks" {
  description = "A list of CIDR blocks to allow access from."
  type        = list(string)
  default     = null
}

variable "source_ipv6_cidr_blocks" {
  description = "A list of IPv6 CIDR blocks to allow access from."
  type        = list(string)
  default     = null
}
