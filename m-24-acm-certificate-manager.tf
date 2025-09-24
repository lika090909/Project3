# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "6.1.0"

#   domain_name = var.domain_name
#   zone_id     = data.aws_route53_zone.mydomain.zone_id



#   validation_method = "DNS"

#   tags = local.common_tags

# }


data "aws_acm_certificate" "issued" {
  domain   = "lalalalalalala7.com"
  statuses = ["ISSUED"]
}

output "aws_acm_certificate_arn" {
  description = "zone id"
  value       = data.aws_acm_certificate.issued.arn

}



