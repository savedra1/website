# 2024

## 31/03 

- Updated file name and added CloudFront to aws infra to allow HTTPS connection.
- ZE9ZvL4.png -> background.png (website-infra/s3/objects.tf) 
- Reformatted s3 bucket endpoint to remove the https:// 
- Testing - hardcoded domain endpoint (2)
- Testing - swapped hardcoded domain name for regional domain name var (13)
- Testing - added hosted zone id to record alias for DNS validation 
- Added cert validation for tf-managed ssl cert
- Added tf managed cert arn var to distribution to replcace manually managed 

## 01/04
    
- Updated Actions workflow to comment TF plan output to the PR (2)
- Reformatted TF linting
