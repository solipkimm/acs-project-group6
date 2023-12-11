# Terraform Config file (main.tf). This has provider block (AWS) and config for provisioning one EC2 instance resource.  

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
#   profile = "default"
  region = "us-east-1"
}

data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-group6-s3bucket"             // Bucket from where to GET Terraform State
    key    = "prod/network/terraform.tfstate"  // Object name in the bucket to GET Terraform State
    region = "us-east-1"                       // Region where bucket created
  }
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = "${var.default_tags}"
  
  name_prefix  = "${var.prefix}-${var.env}"

}



resource "aws_instance" "publicinstance" {
   
    
    count                  = 1
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.projetkey.key_name
    security_groups        = [aws_security_group.publicSG.id]
    subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
    associate_public_ip_address = true  
 
    user_data  = file("${path.module}/install_httpd.sh")
       
     root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = {
      "Name" = "${var.env}-PublicVM-${count.index + 1}"
    }
  
}




resource "aws_instance" "bastion" {
   
    
    count                  = 1
   # name                   = "${var.env}-EC2-${count.index + 1}"
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.projetkey.key_name
    security_groups        = [aws_security_group.bastionSG.id]
    subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
    associate_public_ip_address = true   
  
    user_data  = file("${path.module}/install_httpd.sh")
        
   root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = {
      "Name" = "${var.env}-Bastion-${count.index + 1}"
    }
  
}


resource "aws_instance" "ansibleinstance" {
   
    
    count                  = 2
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.projetkey.key_name
    security_groups        = [aws_security_group.publicSG.id]
    subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[count.index + 2]
    associate_public_ip_address = true  
 
    # user_data  = file("${path.module}/install_httpd.sh")
       
     root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = merge({
      "Name" = "${var.env}-AnsibleVM-${count.index + 3}"
    }, 
    local.default_tags
  )
}



resource "aws_instance" "privateinstance" {
   
    
    count                  = 2
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.projetkey.key_name
    security_groups        = [aws_security_group.privateSG.id]
    subnet_id              = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
    associate_public_ip_address = false
    # user_data  = file("${path.module}/install_httpd.sh")
       
     root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = merge({
      "Name" = "${var.env}-PrivateVM-${count.index +1}"
    }
  )
}




# Adding SSH  key to instance
resource "aws_key_pair" "projetkey" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}


#security Group
resource "aws_security_group" "publicSG" {
  name        = "allow_http_ssh_public"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id 

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



#security Group
resource "aws_security_group" "bastionSG" {
  name        = "allow_http_ssh_bastion"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id 

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


#security Group
resource "aws_security_group" "privateSG" {
  name        = "allow_http_ssh_private"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id 

 

 ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = ["${aws_security_group.bastionSG.id}"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}