# Define environment variable
#variable "environment" {
#  default = "prod"
#}


#Provision public subnets in custom AZ
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  description = "The list of availability zones where the resources will be deployed"
}

#Provision private subnets in custom nonprod VPC
variable "private_subnet_cidrs" {
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}


#Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}



# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "Project"
  type        =  string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
 
  type        = string
  description = "Deployment Environment"
}