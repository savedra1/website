
resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "../website/index.html"
  etag         = filemd5("../website/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_page" {
  bucket = aws_s3_bucket.static_website.id
  key    = "error.html"
  source = "../website/error.html"
  etag   = filemd5("../website/error.html")
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket = aws_s3_bucket.static_website.id
  key    = "styles.css"
  source = "../website/styles.css"
  etag   = filemd5("../website/styles.css")
}

resource "aws_s3_object" "terminal" {
  bucket = aws_s3_bucket.static_website.id
  key    = "terminal.js"
  source = "../website/terminal.js"
  etag   = filemd5("../website/terminal.js")
}

resource "aws_s3_object" "backgroung" {
  bucket = aws_s3_bucket.static_website.id
  key    = "ZE9ZvL4.png"
  source = "../website/ZE9ZvL4.png"
}