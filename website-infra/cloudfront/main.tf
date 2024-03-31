variable "domain_name" {}
variable "cert_id"     {}
variable "regional_domain"      {}
variable "origin_id" {}

output "cf_endpoint" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}