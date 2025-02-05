variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "Project name name"
  default     = "RMRE"
}

variable "resource_group" {
  type        = string
  description = "Resource group"
  default     = "ALS-RMRE"
}

variable "container_registry_sku" {
  type        = string
  description = "Azure Container Registry SKU"
}

variable "location" {
  type        = string
  description = "Azure Location"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags that will be assigned to cloud resources"
  default     = {}
}
