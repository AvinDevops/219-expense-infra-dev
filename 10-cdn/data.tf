## getting enable cache name ##
data "aws_cloudfront_cache_policy" "cache_enable" {
  name = "Managed-CachingOptimized"
}

## getting disable cache name ##
data "aws_cloudfront_cache_policy" "cache_disable" {
  name = "Managed-CachingDisabled"
}

## getting acm certificate ##
data "aws_ssm_parameter" "acm_certificate_arn" {
    name = "/${var.project_name}/${var.environment}/acm_certificate_arn"
}