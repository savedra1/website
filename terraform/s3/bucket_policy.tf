
data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.static_website.arn,  
      "${aws_s3_bucket.static_website.arn}/*"
    ]

    principals {
      identifiers = [aws_s3_bucket.static_website.id]
      type        = "*"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}
