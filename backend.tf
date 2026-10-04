
terraform {
  backend "s3" {
    bucket = "apps-terraform-clusters"
    key    = "eks-n8n-workflow/terraform.tfstate"
    region = "eu-central-1"
  }
}
