terraform {
  source = "../../terraform/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  container_registry_sku = "Basic"
  database_sku = "S0"
  database_storage = 2
}
