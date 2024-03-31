variable "site_bucket_name" {}

output "bucket_zone_id" { # need this for the route53 record alias 
    value = aws_s3_bucket.static_website.hosted_zone_id
}

output "s3_endpoint" {
    value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}