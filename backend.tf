
terraform {
  backend "s3" {
    bucket = "apps-terraform-clusters"
    key    = "eks-sonarqube/terraform.tfstate"
    region = "eu-central-1"
  }
}
