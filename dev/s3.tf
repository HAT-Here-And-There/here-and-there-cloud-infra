module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = format(module.naming.result, "web-bucket")

  force_destroy            = true
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  acl                      = "private"

  # S3 bucket-level Public Access Block configuration (by default now AWS has made this default as true for S3 bucket-level block public access)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  website = {
    index_document = "index.html"
    error_document = "index.html"
    routing_rules  = []
  }

  versioning = {
    enabled = true
  }

  attach_policy = true
  policy = templatefile(
    "./files/static-web-bucket-policy.tftpl",
    {
      s3_bucket_arn = "arn:aws:s3:::${format(module.naming.result, "web-bucket")}"
    }
  )
}
