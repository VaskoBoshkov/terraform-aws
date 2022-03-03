#  --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "max_subnets" {
  type = number
}



variable "security_groups" {}

variable "db_subnet_group" {
  type = bool
}