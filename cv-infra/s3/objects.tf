# Index file object
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.cv_bucket.id
  key    = "cv.pdf"
  source = "../cv.pdf"
  etag   = filemd5("../cv.pdf")
  content_type = "application/pdf"
}
