terraform {
  backend "azurerm" {
    subscription_id      = "f84e5905-7ce0-4716-9d3a-ddd48f487cf4"
    resource_group_name  = "debian-mirror-v2-mgt"
    storage_account_name = "debianmirrorv2terraform"
    container_name       = "prod"
    key                  = "terraform.tfstate"
  }
}
