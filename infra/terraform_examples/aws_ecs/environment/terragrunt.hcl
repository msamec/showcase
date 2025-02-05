remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "example-${path_relative_to_include()}-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "example-${path_relative_to_include()}-terraform-state-lock"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "example-${path_relative_to_include()}-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "example-${path_relative_to_include()}-terraform-state-lock"
  }
}
EOF
}

inputs = {
  project_name      = "example"
  region            = "us-east-1"
  environment       = "${path_relative_to_include()}"
  hosted_zone_id    = "xxx"
  tags              = {
    project     = "example"
    environment = "${path_relative_to_include()}"
    terraform   = "true"
  }
}
