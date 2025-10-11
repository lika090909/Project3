# Apex: lalalalalalala7.com -> CloudFront
resource "aws_route53_record" "apex_to_cf" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "lalalalalalala7.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.alb_origin.domain_name
    zone_id                = aws_cloudfront_distribution.alb_origin.hosted_zone_id # CloudFront = Z2FDTNDATAQYW2
    evaluate_target_health = false
  }
}


# resource "aws_route53_record" "R53_registration_with_www" {
#   zone_id = data.aws_route53_zone.mydomain.zone_id
#   name    = var.domain_name
#   type    = "A"
#   alias {
#     name                   = module.alb_ecs.dns_name
#     zone_id                = module.alb_ecs.zone_id
#     evaluate_target_health = true
#   }
# }


# resource "aws_route53_record" "R53_registration_apex" {
#   zone_id = data.aws_route53_zone.mydomain.zone_id
#   name    = ""        # empty string means the root domain (apex)
#   type    = "A"
#   alias {
#     name                   = module.alb_ecs.dns_name
#     zone_id                = module.alb_ecs.zone_id
#     evaluate_target_health = true
#   }
# }

