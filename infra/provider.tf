terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    # helm = {
    #   source = "hashicorp/helm"
    #   version = "3.0.2"
    # }
  }
}

provider "aws" {
  region = var.aws_region
}

# provider "helm" {
#   kubernetes {
#     config_path = ""
#   }
# }