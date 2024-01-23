variable "ami_id" {
  description = "AMI Id"
  type = string
}

variable "inst_type" {
    description = "Instance type"
    type = string
}

variable "az" {
  description = "Availaility zone"
  type = list(string)
}