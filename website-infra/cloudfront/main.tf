variable "domain_name" {}
variable "cert_id"     {}
variable "s3_endpoint" {}

output "cf_endpoint" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}