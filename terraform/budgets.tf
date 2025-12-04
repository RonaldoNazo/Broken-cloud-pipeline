# # AWS Budget for daily cost monitoring
# resource "aws_budgets_budget" "daily_cost" {
#   name              = "daily-cost-budget"
#   budget_type       = "COST"
#   limit_amount      = var.budget_limit_amount
#   limit_unit        = "USD"
#   time_unit         = "DAILY"
#   time_period_start = "2025-01-01_00:00"

#   cost_filter {
#     name = "TagKeyValue"
#     values = [
#       "product$cloud"
#     ]
#   }

#   notification {
#     comparison_operator        = "GREATER_THAN"
#     threshold                  = 100
#     threshold_type             = "PERCENTAGE"
#     notification_type          = "ACTUAL"
#     subscriber_email_addresses = [var.notification_email]
#   }

#   notification {
#     comparison_operator = "GREATER_THAN"
#     threshold           = 100
#     threshold_type      = "PERCENTAGE"
#     notification_type   = "ACTUAL"

#     subscriber_sns_topic_arns = [aws_sns_topic.alerts.arn]
#   }
# }

# # Enable Cost Allocation Tags
# resource "aws_ce_cost_allocation_tag" "product" {
#   tag_key = "product"
#   status  = "Active"
# }
