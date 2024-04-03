
# Backend setup
terraform {
  backend "s3" {
    bucket = var.CV_STATE_BUCKET
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

# Provider with default region
provider "aws" {
  region = var.AWS_REGION 
}

####################
# MODULES
####################

module "s3" {
  source    = "./s3"
  cv_bucket = var.CV_BUCKET
}

module "cloudfront" {
  source            = "./cloudfront"
  origin_id         = "${module.s3.origin_id}"
  regional_domain   = "${module.s3.regional_domain}"
}

