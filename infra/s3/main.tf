resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "codepipeline_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCodePipelineAccess"
        Effect    = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action    = "s3:*"
        Resource  = [
          "${aws_s3_bucket.codepipeline_bucket.arn}",
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      }
    ]
  })
}
