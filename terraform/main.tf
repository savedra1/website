terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET
    key    = var.STATE_FILE
    region = var.AWS_REGION
  }
}

provider "aws" {
  region     =  var.AWS_REGION 
}

module "route53" {
  source      = "./route53"
  domain_name = var.DOMAIN_NAME
  region      = var.AWS_REGION

}

module "s3" {
  source           = "./s3"
  site_bucket_name = var.SITE_BUCKET
}



