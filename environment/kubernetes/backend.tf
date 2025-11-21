terraform {
 backend "s3" {
   bucket         = "test1111-tf"
   key            = "kubernetes/terraform.tfstate"
   region         = "eu-west-1"
   encrypt        = true
   dynamodb_table = "test1-tf"
 }
}
