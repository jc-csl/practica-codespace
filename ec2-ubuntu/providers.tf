terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # plugin oficial de AWS
      version = "~> 6.0"        # cualquier 6.x
    }
  }
}

# Sin claves: se leen de ~/.aws/credentials (copiadas de AWS Details)
provider "aws" {
  region = var.region # variables.tf
}
