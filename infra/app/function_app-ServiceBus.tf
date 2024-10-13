# #############################################################################
# Azure Function App: Service Bus Handler
# #############################################################################

module "service_bus_function_app" {
  source  = "TaleLearnCode/linux_flex_function_app/azurerm"
  version = "0.0.4-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = "sb"
  resource_group_name = module.resource_group.resource_name
  environment         = var.environment
  location            = var.location

  application_insights_connection_string = module.application_insights.application_insights.connection_string

}