#--- eks/variables.tf ---

variable "cluster_name" {
  type = string
}
variable "subnet_ids" {
  type = list(any)
}

variable "kms_arn" {
  type = string
}

variable "access_cidr" {
  type = list(string)
}