terraform {
  backend "s3" {
    bucket = "s3-marcos-freytag"
    key    = "itau/tfstate1.tfstate"
    region = "us-east-1"
  }
}