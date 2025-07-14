terraform {
  backend "s3" {
    bucket = "s3-marcos-freytag"
    key    = "itau/tfstate.tfstate"
    region = "us-east-1"
  }
}