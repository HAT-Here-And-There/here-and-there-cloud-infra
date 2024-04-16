module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.0"

  origin = {
    hat_web = {
      domain_name = module.s3_bucket.s3_bucket_website_domain
    }
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 200
    response_page_path = "index.html"
    }, {
    error_code         = 403
    response_code      = 200
    response_page_path = "index.html"
  }]

  default_cache_behavior = {
    target_origin_id       = "hat_web"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
  }
}
