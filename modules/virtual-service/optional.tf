variable "name" {
  description = "The name of the virtual service. If null, defaults to product."
  default     = null
  type        = string
}

variable "virtual_router_name" {
  description = "The name of the virtual router this virtual service is associated with. If null, it's assumed that virtual_node_name is populated."
  default     = null
  type        = string
}

variable "virtual_node_name" {
  description = "The name of the virtual node this virtual service is associated with. If null, it's assumed that virtual_router_name is populated."
  default     = null
  type        = string
}
