variable "cv_bucket" {}

output "regional_domain" { # needed for cloudfront dist
    value = aws_s3_bucket.cv_bucket.bucket_regional_domain_name
}

output "origin_id" {       # needed for cloudfront dist
    value = aws_s3_bucket.cv_bucket.bucket_domain_name
}