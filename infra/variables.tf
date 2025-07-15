variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account" {
  default = "114368227931"
}

variable "sg_access_ip" {
  type    = string
  default = "200.192.99.36/32"
}

variable "app_port" {
  default = 443

}

variable "cluster_name" {
  type = string
  default = "eks-sre1"
}