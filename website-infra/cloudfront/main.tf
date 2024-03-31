variable "domain_name" {}
variable "cert_id"     {}
variable "region"      {}

output "cf_endpoint" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}