variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}


#Default tags for resources
variable "tags"{
    description     = "Default tags"
    type            = map(string)
    default         = {
        owner       = "michael.appiah.dankwah"
        expiration_date = "03-03-2024"
        bootcamp    = "ghana2"
        workspace   = "mike-org-test"
    }
}

variable "ami_id" {
  description = "AMI Id"
  type = string
  default = "ami-0d3f444bc76de0a79"
}

variable "inst_type" {
    description = "Instance type"
    type = string
    default = "t3a.large"
}

variable "az" {
  description = "Availaility zone"
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}