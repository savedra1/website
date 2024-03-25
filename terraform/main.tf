terraform {
  backend "s3" {
    bucket = vars.STATE_BUCKET
    key    = "dev/tfstate"
    region = "eu-west-1" #vars.AWS_REGION
  }
}

provider "aws" {
  region     =  vars.AWS_REGION 
}

module "route53" {
  source      = "./route53"
  domain_name = vars.DOMAIN_NAME
  region      = vars.AWS_REGION

}

module "s3" {
  source           = "./s3"
  site_bucket_name = vars.SITE_BUCKET
}



