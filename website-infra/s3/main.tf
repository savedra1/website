variable "site_bucket_name" {}

output "bucket_zone_id" { # need this for the route53 record alias 
    value = aws_s3_bucket.static_website.hosted_zone_id
}

output "regional_domain" {
    value = aws_s3_bucket.static_website.bucket_regional_domain_name
}

output "origin_id" {
    value = aws_s3_bucket.static_website.bucket_domain_name
}