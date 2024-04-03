
# Output cf domain to txt file for html file to read form
resource "null_resource" "write_endpoint_to_file" { 
  provisioner "local-exec" {
    command = "echo 'Cloudfront domain for cv: ${module.cloudfront.cf_domain}'"
  }
}
