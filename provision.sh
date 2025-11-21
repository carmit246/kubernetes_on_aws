cd environment/remote-state
terraform init
terraform apply -auto-approve
cd ../networking
terraform init
terraform apply -auto-approve
cd ../kubernetes
terraform init
terraform apply -auto-approve
cd ../argocd
terraform init
terraform apply -auto-approve
cd ../applications
terraform init
terraform apply -auto-approve