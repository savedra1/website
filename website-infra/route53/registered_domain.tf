
resource "aws_route53domains_registered_domain" "my_domain" {
  domain_name = var.domain_name

  name_server {
    name = aws_route53_zone.hosted_zone.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.hosted_zone.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.hosted_zone.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.hosted_zone.name_servers[3]
  }
}