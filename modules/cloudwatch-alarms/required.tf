variable "namespace" {
  description = "The namespace for the alarm's associated metric. Supports AWS managed namespaces (e.g. AWS/Lambda, AWS/Kinesis, AWS/States, AWS/SES, AWS/SQS, AWS/MediaTailor) and custom application namespaces."
  type        = string
}
