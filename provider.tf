terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 1.2.0"
    }
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}    

#provider "external" {}