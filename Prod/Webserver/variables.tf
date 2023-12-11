# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t2.micro"
    "nonprod"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}


#Provision public subnets in custom AZ
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  description = "The list of availability zones where the resources will be deployed"
}


# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group10"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "projectkey"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}
