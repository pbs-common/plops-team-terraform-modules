variable "name" {
  description = "Name of the virtual gateway. Will default to product if not defined."
  default     = null
  type        = string
}

variable "container_name" {
  description = "Name of the containers running the envoy service for the virtual gateway"
  default     = "envoy"
  type        = string
}

variable "container_port" {
  description = "Port the envoy service will expose"
  default     = 8080
  type        = number
}

variable "load_balancer_type" {
  description = "Type of load balancer to use for the envoy service"
  default     = "network"
  type        = string
}

variable "aliases" {
  description = "CNAME(s) that are allowed to be used for the envoy service. Default is `product`.`primary_hosted_zone`. e.g. [product.example.com] --> [example.com]"
  default     = null
  type        = list(string)
}

variable "cnames" {
  description = "CNAME(s) that are going to be created for the envoy service in the primary_hosted_zone. This can be set to [] to avoid creating a CNAME for the app. This can be useful for CDNs. Default is `product`. e.g. [product] --> [product.example.com]"
  default     = null
  type        = list(string)
}

variable "listener_protocol" {
  description = "The listener protocol for the virtual gateway"
  default     = "http"
  type        = string
}

variable "primary_hosted_zone" {
  description = "Name of the primary hosted zone for DNS. e.g. primary_hosted_zone = example.org --> service.example.org. If null, it is assumed that a private hosted zone will be used."
  default     = null
  type        = string
}

variable "private_hosted_zone" {
  description = "Name of the private hosted zone for DNS. e.g. private_hosted_zone = example.org --> service.example.private. If null, it is assumed that a public hosted zone will be used."
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "VPC ID. If null, one will be looked up based on environment tag."
  default     = null
  type        = string
}

variable "subnets" {
  description = "Subnets for the Virtual Gateway service. If null, private and public subnets will be looked up based on environment tag and one will be selected based on public_service."
  default     = null
  type        = list(string)
}

variable "public_service" {
  description = "Service should be provisioned in public subnet. Ignored if subnets defined."
  default     = true
  type        = bool
}

variable "min_capacity" {
  description = "The minimum capacity of tasks for this service"
  default     = 1
  type        = number
}

variable "max_capacity" {
  description = "The maximum capacity of tasks for this service"
  default     = 2
  type        = number
}

variable "cluster" {
  description = "ECS cluster for service"
  default     = null
  type        = string
}
