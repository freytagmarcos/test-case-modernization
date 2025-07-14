terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.17.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "mongodbatlas" {
}