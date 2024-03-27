variable "site_bucket_name" {}

output "route_zone_id" {
    value = aws_s3_bucket.static_website.zone_id
}
