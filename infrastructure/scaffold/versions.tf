terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
  }

  backend "s3" {
    bucket = "master-the-legacy"
    key    = "tf-states/infrastructure/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  default_tags {
    tags = {
      project = var.project
      owners  = "minders"
    }
  }
}
