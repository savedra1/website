variable "domain_name" {}
variable "cert_id" {}

output "cf_endpoint" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}