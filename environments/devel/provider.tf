# SPDX-License-Identifier: GPL-3.0-or-later

provider "azurerm" {
  subscription_id = var.subscription_id

  skip_provider_registration = true

  features {
  }
}
