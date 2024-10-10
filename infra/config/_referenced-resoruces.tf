# #############################################################################
# Referenced resources
# #############################################################################

data "azurerm_client_config" "current" {}

data "azuread_service_principal" "terraform" {
  display_name = var.terraform_service_principal
}