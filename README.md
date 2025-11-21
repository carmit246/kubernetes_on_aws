# kubernetes_on_aws
This repository includes terraform code to deploy AWS infrastructure to run the hello-world backend application.

## Prerequisites
#### install aws cli
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -f awscliv2.zip
```
#### login to aws 
```
aws configure
```
provide the inputs to login

if available, use ```aws sso login```

#### install terraform
```
wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
```

## Provision infrastruture

#### Run provision script:
```
chmod +x provision.sh
./provision.sh
```
```provision.sh``` script, runs 5 TF folders in sequence:
1. S3 bucket and DynamoDB table for terraform state
2. VPC (and related networking resources)
3. EKS cluster (auto-mode) and ECR Repository
4. Argocd deployment
5. ArgoCD application for hello-world backend app