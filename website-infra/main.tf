
# Backend setup
terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

# Provider with default region
provider "aws" {
  region = var.AWS_REGION 
}

# Certificate manager
module "acm" {
  source      = "./acm"
  domain_name = var.DOMAIN_NAME
  cert_record = module.route53.cert_record
}

# AWS Cloudfront
module "cloudfront" {
  source           = "./cloudfront"
  domain_name      = var.DOMAIN_NAME
  cert_id          = "${module.acm.cert_id}"
  regional_domain  = "${module.s3.regional_domain}"
  origin_id        = "${module.s3.origin_id}"
}

# Route53
module "route53" {
  source                    = "./route53"
  domain_name               = var.DOMAIN_NAME
  region                    = var.AWS_REGION
  bucket_zone_id            = "${module.s3.bucket_zone_id}"
  cloudfront_endpoint       = "${module.cloudfront.cloudfront_endpoint}"
  cloudfront_zone_id        = "${module.cloudfront.cloudfront_zone_id}"
  domain_validation_options = module.acm.domain_validation_options
}

# Site bucket
module "s3" {
  source           = "./s3"
  site_bucket_name = var.SITE_BUCKET
}
