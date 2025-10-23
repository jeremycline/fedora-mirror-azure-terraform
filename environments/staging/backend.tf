terraform {
  backend "azurerm" {
    subscription_id      = "8ddde9ba-f5e7-4a4f-a9a1-64181b250697"
    resource_group_name  = "fedora-mirror"
    storage_account_name = "fedoramirrorterraform"
    container_name       = "v1-staging"
    key                  = "terraform.tfstate"
  }
}
