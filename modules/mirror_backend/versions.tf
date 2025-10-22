# SPDX-License-Identifier: GPL-3.0-or-later

terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.49"
    }
  }
}
