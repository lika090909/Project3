# ## SNS - Topic
# resource "aws_sns_topic" "myasg_sns_topic" {
#   name = "myasg-sns-topic"
# }

# ## SNS - Subscription
# resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
#   topic_arn = aws_sns_topic.myasg_sns_topic.arn
#   protocol  = "email"
#   endpoint  = "likulya157@gmail.com"
# }

# resource "aws_autoscaling_notification" "myasg_notifications" {
#   group_names = toset(concat(
#     [for m in module.autoscaling_app1 : m.autoscaling_group_name],
#     [for m in module.autoscaling_app2 : m.autoscaling_group_name],
#     [for m in module.autoscaling_app3 : m.autoscaling_group_name]
#   ))

#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
#     "autoscaling:TEST_NOTIFICATION",
#   ]

#   topic_arn = aws_sns_topic.myasg_sns_topic.arn
# }git add