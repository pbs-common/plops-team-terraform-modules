variable "security_group_id" {
  description = "The ID of the security group that contains the rule."
  type        = string
}

variable "description" {
  description = "Description of the rule. This must clearly describe the purpose of the rule."
  type        = string
}
