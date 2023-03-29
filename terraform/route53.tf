resource "aws_route53_zone" "private" {
  name = "lab.splunk"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "lm" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "lm.lab.splunk"
  type    = "A"
  ttl     = 300
  records = [module.license_manager.private_ip]
}

resource "aws_route53_record" "im" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "im.lab.splunk"
  type    = "A"
  ttl     = 300
  records = [module.indexer_manager.private_ip]
}

resource "aws_route53_record" "ds" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "ds.lab.splunk"
  type    = "A"
  ttl     = 300
  records = [module.deployment_server.private_ip]
}
