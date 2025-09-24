resource "aws_cloudfront_function" "redirect_root" {
  name    = "redirect-root-to-login"
  runtime = "cloudfront-js-1.0"
  comment = "Redirect / to /login"
  publish = true

  code = file("${path.module}/m-33.2-CloudFront-redirect-root.js")
}
