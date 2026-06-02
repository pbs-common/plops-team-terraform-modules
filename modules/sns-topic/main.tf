resource "aws_sns_topic" "topic" {
  name = local.name

  fifo_topic = var.fifo_topic

  tags = local.tags
}

resource "aws_sns_topic_policy" "policy" {
  count = var.create_topic_policy ? 1 : 0

  arn    = aws_sns_topic.topic.arn
  policy = var.topic_policy != null ? var.topic_policy : data.aws_iam_policy_document.policy.json
}
