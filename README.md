# kubernetes_on_aws

### Install and configure tools
install aws cli
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -f awscliv2.zip
```
login to aws
```
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="region"
```
install terraform
```
wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
```

## Option 1: Single state file provisioning

### Deploy bootstrap (creates S3 bucket for state)
```
cd bootstrap
terraform init
terraform plan
terraform apply
```

### Deploy Network architecture and EKS cluster and ECR
```
cd ..
terraform init
terraform plan
terraform apply
```

### Deploy ArgoCD
```
cd argocd
terraform init
terraform plan
terraform apply
```

## Option 2: Multiple state file provisioning

### Serial run of the terraform code, 3 separate state files: networking, kubernetes and argocd
```
cd environments/dev
provision.sh
```