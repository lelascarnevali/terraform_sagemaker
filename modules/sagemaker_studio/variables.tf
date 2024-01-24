variable "domain_name" {
  type    = string
  default = "domain_test"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

#variable "security_group_ids" {
#  type = list(string)
#}

variable "user_names" {
  type    = list(string)
  default = ["default"]
}

variable "sample_repository" {
  type    = string
  default = "https://github.com/gabrielmartinigit/pyspark-samples"
}


variable "arn_exec_role" {
  type    = string
}