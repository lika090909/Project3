resource "aws_route53_record" "R53_registration_with_www" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = module.alb_ecs.dns_name
    zone_id                = module.alb_ecs.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "R53_registration_apex" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = ""        # empty string means the root domain (apex)
  type    = "A"
  alias {
    name                   = module.alb_ecs.dns_name
    zone_id                = module.alb_ecs.zone_id
    evaluate_target_health = true
  }
}

