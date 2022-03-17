terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  #  access_key = "AKIAWBFHDEMM4K76HYRC"
  #secret_key = "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"
  access_key = "AKIAWBFHDEMMZPSFSCO3"
  secret_key = "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"

}

