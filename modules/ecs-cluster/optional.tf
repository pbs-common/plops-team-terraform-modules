variable "name" {
  description = "Name of the cluster"
  default     = null
  type        = string
}

variable "ec2_backed" {
  description = "Whether or not to provision an autoscaled EC2 fleet to back the cluster"
  default     = false
  type        = bool
}

variable "instance_type" {
  description = "Instance type to use for EC2 backed cluster"
  default     = "m5a.xlarge"
  type        = string
}

variable "max_size" {
  description = "Maximum size for the autoscaling group to scale out to for the cluster"
  default     = 25
  type        = number
}

variable "min_size" {
  description = "Minimum size for the autoscaling group to scale out to for the cluster"
  default     = 3
  type        = number
}

variable "vpc_id" {
  description = "VPC ID. If null, one will be looked up based on environment tag."
  default     = null
  type        = string
}

variable "subnets" {
  description = "Subnets for the service. If null, private and public subnets will be looked up based on environment tag and one will be selected based on public_service."
  default     = null
  type        = list(string)
}

variable "role_policy_json" {
  description = "(optional) IAM policy to attach to role used for this task"
  default     = null
  type        = string
}

variable "max_instance_lifetime" {
  description = "Maximum lifetime for an instance in the autoscaling group"
  default     = 604800 # 1 week
  type        = number
}

variable "protect_from_scale_in" {
  description = "Prevent ECS auto-scaling from terminating instances on scale-in. Must be false when destroying cluster"
  default     = false
  type        = bool
}

variable "maximum_scaling_step_size" {
  description = "Capacity provider maximum scaling step size"
  default     = 10
  type        = number
}

variable "minimum_scaling_step_size" {
  description = "Capacity provider maximum scaling step size"
  default     = 1
  type        = number
}

variable "target_capacity" {
  description = "Capacity provider target capacity"
  default     = 75
  type        = number
}

variable "launch_template_version" {
  description = "Version of the launch template to use"
  default     = "$Latest"
  type        = string
}
