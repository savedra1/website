variable "origin_id"       {}
variable "regional_domain" {}

output "cf_domain" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}