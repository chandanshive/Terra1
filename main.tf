resource "aws_instance" "web" {
  ami           = "ami-01e36b7901e884a10"
  instance_type = "t3.micro"

  tags = {
    Name = "web"
  }

  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "required"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name = "bucket"
  }

  logging {
    target_bucket = "<target_bucket_name>"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "bucketPolicy" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket-restrict-access-to-users-or-roles",
      "Effect": "Allow",
      "Principal": [
        {
          "AWS": [
            "arn:aws:iam::##acount_id##:role/##role_name##",
            "arn:aws:iam::##acount_id##:user/##user_name##"
          ]
        }
      ],
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
    }
  ]
}
POLICY
}