terraform {
  backend "azurerm" {
    subscription_id      = "f84e5905-7ce0-4716-9d3a-ddd48f487cf4"
    resource_group_name  = "fedora-mirror"
    storage_account_name = "fedoramirrorterraform"
    use_azuread_auth     = true
    container_name       = "v1-prod"
    key                  = "terraform.tfstate"
  }
}
