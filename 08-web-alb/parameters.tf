## creating web-alb listener arn ##
resource "aws_ssm_parameter" "web_alb_listener_arn_http" {
    name = "/${var.project_name}/${var.environment}/web_alb_listener_arn_http"
    type = "String"
    value = aws_lb_listener.http.arn
}

## creating web-alb listener arn ##
resource "aws_ssm_parameter" "web_alb_listener_arn_https" {
    name = "/${var.project_name}/${var.environment}/web_alb_listener_arn_https"
    type = "String"
    value = aws_lb_listener.https.arn
}