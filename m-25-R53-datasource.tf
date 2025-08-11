

data "aws_route53_zone" "mydomain" {
  name         = "lalalalalalala7.com."
  private_zone = false
}


output "zone_id" {
  description = "zone id"
  value = data.aws_route53_zone.mydomain.zone_id
  
}

