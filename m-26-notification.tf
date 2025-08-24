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

# ## Create Autoscaling Notification Resource
# resource "aws_autoscaling_notification" "myasg_notifications" {
#   group_names = [module.autoscaling_app1.autoscaling_group_id , module.autoscaling_app2.autoscaling_group_id, module.autoscaling_app3.autoscaling_group_id ]
#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
#     "autoscaling:TEST_NOTIFICATION"
#   ]
#   topic_arn = aws_sns_topic.myasg_sns_topic.arn 
# }

