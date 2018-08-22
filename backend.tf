terraform {
  backend "s3" {
    bucket = "myvpcstate"
    key    = "vpc/terraform.state"
    region = "us-east-1"
  }
}
