#--- eks/variables.tf ---

variable "cluster_name" {
  type = string
}
variable "subnet_ids" {
  type = list(any)
}

variable "access_cidr" {
  type = list(string)
}

variable "policy_arn" {
  type = string
}

variable "principal_arn" {
  type = string
}