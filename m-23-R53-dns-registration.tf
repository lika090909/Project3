
# Origin subdomain: origin.example.com -> ALB
resource "aws_route53_record" "alb_origin" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "origin.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb_ecs.dns_name   # ✅ ALB DNS from module
    zone_id                = module.alb_ecs.zone_id    # ✅ ALB Zone ID from module
    evaluate_target_health = true
  }
}
