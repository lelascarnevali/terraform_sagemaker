variable "cluster_name" {
  type    = string
  default = "cluster_test"
}

variable "emr_version" {
  type    = string
  default = "emr-6.10.0"
}

variable "cluster_applications" {
  type = list(string)
}

variable "master_instance_type" {
  type    = string
  default = "m5.xlarge"
}

variable "master_instance_count" {
  type    = number
  default = 1
}

variable "core_instance_type" {
  type    = string
  default = "m5.xlarge"
}

variable "core_instance_count" {
  type    = number
  default = 1
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = string
}
