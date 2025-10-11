resource "aws_cloudfront_origin_request_policy" "all_viewer_with_auth" {
  name = "AllViewerSimple"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host", "Origin", "Referer"]
    }
  }

  cookies_config {
    cookie_behavior = "all"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}
