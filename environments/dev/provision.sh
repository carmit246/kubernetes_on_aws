cd remote-state
terraform init
terraform apply -auto-approve
cd ../networking
terraform init
terraform apply -auto-approve
cd ../kubernetes
terraform init
terraform apply -auto-approve
cd ..