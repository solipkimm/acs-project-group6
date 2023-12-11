terraform  {
  backend "s3" {
    bucket = "acs730-group6-s3bucket"            // Bucket from where to GET Terraform State
    key    = "prod/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                       // Region where bucket created
  }
}