resource "aws_route53_zone" "private" {
  name = var.domain_name

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "lm" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "lm.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [module.license_manager.private_ip]
}

resource "aws_route53_record" "im" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "im.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [module.indexer_manager.private_ip]
}

resource "aws_route53_record" "ds" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "ds.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [module.deployment_server.private_ip]
}
