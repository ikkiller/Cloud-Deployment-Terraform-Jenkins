resource "aws_iam_policy" "ec2_cloudwatch_metrics" {
  name        = "EC2-CloudWatch-Metrics-Policy"
  description = "Allows EC2 to push metrics to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_metrics" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_metrics.arn
}
resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}