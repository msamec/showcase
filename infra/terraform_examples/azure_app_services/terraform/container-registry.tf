locals {
  container_name = "${var.project}${var.env}"
}

resource "azurerm_container_registry" "acr" {
  name                = local.container_name
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.container_registry_sku
  admin_enabled       = true

  tags = var.tags
}
