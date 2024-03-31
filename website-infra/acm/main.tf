
provider "aws" {
    region = "us-east-1" # cert must be in this region to be accepted by cloudfront
}

variable "domain_name" {}
variable "cert_record" {}

output "cert_id" {
  value = aws_acm_certificate.domain_cert.arn
}

output "domain_validation_options" {
    value = aws_acm_certificate.domain_cert.domain_validation_options
}