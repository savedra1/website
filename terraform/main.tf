terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET
    key    = "dev/tfstate"
    region = vars.AWS_REGION
  }
}

provider "aws" {
  region     =  var.AWS_REGION 
}

module "route53" {
  source      = "./route53"
  domain_name = var.DOMAIN_NAME
  region      = var.AWS_REGION
  zone_id = "${module.s3.route_zone_id}"

}

module "s3" {
  source           = "./s3"
  site_bucket_name = var.SITE_BUCKET
}



