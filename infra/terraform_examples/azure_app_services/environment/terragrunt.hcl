remote_state {
    backend = "azurerm" 
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        storage_account_name = "saterraform"
        container_name       = "tfstate"
        key                  = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name  = "ALS-RMRE"
        subscription_id      = "xxx"
    }
  }

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1.9.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.16.0"
    }
  }
}

provider "azurerm" {
  subscription_id            = "xxx"
  tenant_id                  = "xxx"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
EOF
}

inputs = {
  location = "eastus"
  project  = "example"
  env      = "${path_relative_to_include()}"
  tags     = {
    environment = "${path_relative_to_include()}"
    project     = "example"
    terraform   = "true"
  }
}
