module "example" {
  source = "TaleLearnCode/naming/azurerm"
  version = "0.0.2-pre"

  resource_type  = "key_vault"
  name_prefix    = "myapp"
  srv_comp_abbr  = "db"
  name_suffix    = "001"
  location       = "northcentralus"
  environment    = "prod"
}

output "example" {
  value = module.example.resource_name # kv-myappdb001-usnc-prod
}