# Cloud Automation and Control Systems
**Project: Two-Tier web application automation with Terraform, Ansible, and GitHub Actions**

## Collaborators
| Name                         | GitHub Profile                                           |
| ---------------------------- | -------------------------------------------------------- |
| Aanchal Thakur               | [aanchalthakur28](https://github.com/aanchalthakur28)    |
| Manickavasagam Arunachalam   | [mvasu745](https://github.com/mvasu745)                  |
| Neethu Paul                  | [npaul1909](https://github.com/npaul1909)                |
| Nisal Chandana Ekanayake     | [NisalC](https://github.com/NisalC)                      |
| Solip Kim                    | [solipkimm](https://github.com/solipkimm)                |

## Architecture
![image](https://github.com/solipkimm/acs-project-group6/assets/59662367/a38d274e-8b54-4d59-adc2-e5ae260cda6f)

## Overview
The project focuses on building a robust two-tier web application automation solution using Terraform, Ansible, and GitHub Actions, specifically designed for the Amazon Web Services (AWS) environment. The architecture comprises 6 Virtual Machines (VMs) distributed across 4 Public and 2 Private Subnets in distinct availability zones.

## Features
- **Network Architecture:** The infrastructure comprises four Public Subnets for accessibility and two Private Subnets for enhanced security. Webserver (VM #2) plays a crucial role as a Bastion host, facilitating secure access to VMs (#5 and #6) residing in Private subnets.
- **Ansible Configuration Management:** Utilizing Ansible Playbooks and Dynamic Inventory, the configuration of WebServers 3 and 4 in the Public Subnet involves comprehensive checks, including connectivity verification, service status validation, and patch updates.
- **GitHub Collaboration:** The entire project, encompassing both Terraform and Ansible code, is hosted on GitHub to ensure version control, collaboration, and traceability.
- **GitHub Actions:** GitHub Actions is used to perform security scan on each push to staging branch and when pull request is open to merge code into prod branch. Also it is employed to Automate future deployment of Terraform code for provisioning the Infrastucture resources and the first two Webservers.

## Getting Started
To get started with the Two-Tier Web Application Automation framework, follow these simple steps:

1. Clone the repository in Cloud9:

   ```console
   git init
   git clone https://github.com/solipkimm/two-tier-web-automation.git
   ```
2. Create S3 Bucket in AWS for Terraform State
3. Update Backend S3 configuration in the below files.

   - `Network/config.tf`
   - `Webserver/config.tf`
   - `Webserver/main.tf`
  
4. Create SSH key pairs for Prod (Make sure to have a public key in Prod/Webserver/)
   ```console
   ssh-keygen -t rsa -f ~/.ssh/projectkey
   ```
5. Deploy the network infrastructure:

   ```console
   alias tf=terraform
   cd Prod/Network
   tf fmt
   tf validate
   tf plan
   tf apply -auto-approve
   ```

5. Deploy the webserver infrastructure:

   ```console
   cd Prod/Webserver
   tf fmt
   tf validate
   tf plan
   tf apply -auto-approve
   ```
6. Install Ansible and required dependencies:

   ```console
   sudo yum install –y ansible
   sudo pip2.7 install boto3
   ```
7. Update ansible configuration:
   
   ```console
   sudo vim /etc/ansible/ansible.cfg
   ```
   Add the following line inside the config file and save.
   ```console
   enable_plugins = aws_ec2
   ```
8. Run the Ansible playbook:
   
   ```console
   cd Ansible
   ansible-playbook -i aws_ec2.yaml playbook.yaml
   ```

9. GitHub Actions for Automation
   - Push to 'staging' branch and Pull request to 'prod' branch will scan security.
   - Pull request to 'prod' branch will deploy terraform.
   
