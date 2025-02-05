locals {
  service_plan_name = "${var.project}${var.env}"
  app_name = "${var.project}${var.env}"
}

resource "azurerm_service_plan" "plan" {
  name                = local.service_plan_name
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = var.tags
}

resource "azurerm_linux_web_app" "rmre" {
  name                = local.app_name
  resource_group_name = var.resource_group
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name = "example:tag"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    } 
  }

  tags = var.tags
}
