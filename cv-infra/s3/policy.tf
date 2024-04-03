# Public access policy (dynamic so always shows as a planned change)
data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.cv_bucket.arn,  
      "${aws_s3_bucket.cv_bucket.arn}/*"
    ]

    principals {
      identifiers = [aws_s3_bucket.cv_bucket.id]
      type        = "*"
    }
  }
}

# Attach policy to bucket
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.cv_bucket.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}
