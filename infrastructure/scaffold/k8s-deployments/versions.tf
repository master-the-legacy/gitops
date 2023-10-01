terraform {
  required_version = "~> 1.5.3"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }

  backend "s3" {
    bucket = "master-the-legacy"
    key    = "tf-states/infrastructure/scaffold/k8s-deployments/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
