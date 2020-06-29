# SPDX-License-Identifier: GPL-3.0-or-later

provider "azurerm" {
  version = "~> 2.11"

  subscription_id = "f84e5905-7ce0-4716-9d3a-ddd48f487cf4"

  skip_provider_registration = true

  features {
  }
}
