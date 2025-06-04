# Minecraft Server on AWS using Terraform

## Overview
In this tutorial, we are going to create a Minecraft server using Terraform, Ansible and AWS CLI.

## Installation

### AWS CLI Installation

**MacOS:**

ln -s /folder/installed/aws-cli/aws /usr/local/bin/aws
ln -s /folder/installed/aws-cli/aws_completer /usr/local/bin/aws_completer


**Windows:**

msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi


**Linux:**

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


### Terraform Installation

**MacOS:**

brew tap hashicorp/tap


**Windows:**

choco install terraform


**Linux:**

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common


### Ansible Installation

**MacOS:**

brew install ansible


**Windows:**

Not native, need to use WSL


**Linux:**

sudo apt install ansible


## Setup

1. Import AWS Credentials:
   - Navigate to your AWS Learner Tab and click AWS Details
   - Click "Show" next to AWS CLI
   - Copy contents to ~/.aws/credentials

2. Clone the repository:

git clone <repository_url>


## Deployment

1. Run Terraform:

terraform apply -auto-approve

2. in ansible/inventory.ini change your_ip to the public ip

3. Run ansible-playbook -i ansible/inventory.ini playbook.yml

2. Verify server is running:

nmap -sV -Pn -p 25565 your__public_ip

(Use the IP from terraform output)

3. Connect via Minecraft 1.20.4 using the public IP

## References
- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

