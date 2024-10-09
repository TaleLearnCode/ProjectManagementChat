terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
}

data "azuread_client_config" "current" {}

variable "service_principal_name" {
  type        = string
  description = "The name of the service principal"
}

resource "azuread_application" "catalog_developer" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "catalog_developer" {
  client_id                    = azuread_application.catalog_developer.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "catalog_developer" {
  service_principal_id = azuread_service_principal.catalog_developer.object_id
}

resource "local_file" "example" {
  content  = <<EOF
Service Principal Name: ${var.service_principal_name}
Client ID: ${azuread_service_principal.catalog_developer.client_id}
Client Secret: ${azuread_service_principal_password.catalog_developer.value}
Tenant ID: ${data.azuread_client_config.current.tenant_id}
EOF
  filename = "${path.module}/service_principal_credentials.txt"
}