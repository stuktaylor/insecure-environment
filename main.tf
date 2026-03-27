terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Backend is configured via backend.tfvars after running bootstrap/
  # Copy backend.tfvars.example to backend.tfvars, fill in the values from
  # bootstrap outputs, then run: terraform init -backend-config=backend.tfvars
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}
