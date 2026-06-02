variable "topic_arn" {
  description = "The ARN of the SNS topic to subscribe to"
  type        = string
}

variable "protocol" {
  description = "The protocol to use. See this for more info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#protocol."
  type        = string
}

variable "endpoint" {
  description = "The endpoint to send data to, the contents will vary with the protocol. See this for more info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#endpoint."
  type        = string
}
