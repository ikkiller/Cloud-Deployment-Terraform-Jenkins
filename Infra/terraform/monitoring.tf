//// EC2 Health Check ////
resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  alarm_name          = "ec2-status-check-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Triggered if EC2 instance fails system status check"
  actions_enabled     = false

  dimensions = {
    InstanceId = aws_instance.web-server.id
  }
}

//// Http health check ////
# 2. Custom Nginx HTTP Check
# -----------------------------
resource "aws_cloudwatch_metric_alarm" "nginx_http_check" {
  alarm_name          = "nginx-http-check-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCheckFailed"
  namespace           = "Custom/WebService"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggered if Nginx HTTP check fails"
  actions_enabled     = false

  dimensions = {
    InstanceId = aws_instance.web-server.id
  }
}

