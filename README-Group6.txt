Follow these below steps to deploy webservers using terraform and ansible-playbook


Deployment Prerequisites:
*************************************************************************

Start with creating S3 buckets to store the terraform state

1. S3 Bucket for Terraform State:

Create one S3 bucket to store the Terraform state for Prod environment.
Update the backend configuration in the below files with the correct bucket detail.
1) Network/config.tf
2) Webserver/config.tf
3) Webserver/main.tf

2. SSH Key Pair: 

Create one SSH key pairs for Prod.
Make sure to have a public key in this location : >>  acs_project_group6/Prod/Webserver/



Deployment Process :
**************************************************************************

1)Clone the repository to your local machine:

git init
git clone https://github.com/solipkimm/acs-project-group6.git


2)The networking module used in the deployment and it has the configuration for creating the VPC, subnets, and associated networking components.

Module Usage in Configuration:
The module is utilised in the configuration files (Prod/Network/main.tf).


Deploy the network infrastructure:

3)Switch to acs-project-group6/Prod/Network and execute the following commands:

alias tf=terraform

tf fmt
tf validate
tf plan
tf apply -auto-approve

This code is used to setup the networking configuration.


3)Switch to acs-project-group6/Prod/Webserver and execute the following commands:

alias tf=terraform

tf fmt
tf validate
tf plan
tf apply -auto-approve

This will deploy the webservers using terraform

Note : Successfully deployed four VM's using terraform



4)Follow the below steps to deploy the webserver using ansible playbooks


Install Ansible and required dependencies:

sudo yum install –y ansible # Run this command to install ansible
sudo pip2.7 install boto3 #Install the boto3 library for Python 2.7 with administrative privileges

Update ansible configuration : sudo vi /etc/ansible/ansible.cfg
Add the following command inside the config file : enable_plugins = aws_ec2
This will enable the  AWS EC2 inventory plugin.


Run the Ansible playbook:

ansible-playbook -i aws_ec2.yaml playbook.yaml


GitHub Actions for Automation

Creating pull request to 'prod' branch will deploy terraform.


