variable "domain_name" {}
variable "cert_id"     {}
variable "regional_domain"      {}
variable "origin_id" {}

output "cloudfront_endpoint" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}

output "cloudfront_zone_id" {
    value = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
}