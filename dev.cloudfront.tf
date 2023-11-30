resource "aws_cloudfront_distribution" "s3_dev-distribution" {
  origin {
    domain_name              = aws_s3_bucket.S3Prod_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.S3Prod_cdn_origin-access-control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Comment about deploying CDN for my S3 bucket"
  default_root_object = "index.html"
  aliases = [ "dev.dennisowie.com" ]


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" 
    min_ttl                = 0
    default_ttl            = 3600       
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Name = "S3Prod_dev-Environment"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = "arn:aws:acm:us-east-1:806066816337:certificate/737574cd-1c58-431a-8e69-8051b3d340da"
    ssl_support_method = "sni-only"
  
  }  
}