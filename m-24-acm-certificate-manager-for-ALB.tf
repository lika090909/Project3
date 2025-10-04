data "aws_acm_certificate" "alb_cert" {
  domain       = "origin.lalalalalalala7.com"
  statuses     = ["ISSUED"]
  most_recent  = true
}