terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region     =  var.AWS_REGION 
}

module "acm" {
  source      = "./acm"
  domain_name = var.DOMAIN_NAME
}

/*
module "cf" {
  source      = "./cloudfront"
  domain_name = var.DOMAIN_NAME
  cert_id     = "${module.acm.cert_id}"
  regional_domain  = "${module.s3.regional_domain}"
  origin_id = "${module.s3.origin_id}"
}*/

module "route53" {
  source         = "./route53"
  domain_name    = var.DOMAIN_NAME
  region         = var.AWS_REGION
  bucket_zone_id = "${module.s3.bucket_zone_id}"
  #cf_endpoint    = "${module.cf.cf_endpoint}"
}

module "s3" {
  source           = "./s3"
  site_bucket_name = var.SITE_BUCKET
}

