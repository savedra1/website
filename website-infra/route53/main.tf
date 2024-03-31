variable "domain_name"             {}
variable "region"                  {}
variable "bucket_zone_id"          {} 
variable "cloudfront_endpoint"     {}
variable "cloudfront_zone_id"      {}
variable "domain_validation_options" {}

output "cert_record" {
    value = aws_route53_record.cert_record
}