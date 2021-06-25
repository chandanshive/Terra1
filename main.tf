resource "aws_instance" "web" {
  ami           = "ami-01e36b7901e884a10"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
  }
}
