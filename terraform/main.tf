terraform {
  required_version = ">= 1.5"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# --- Security group (least-privilege building block) ---
resource "azuread_group" "finance" {
  display_name     = "SEC-Finance-ReadOnly"
  security_enabled = true
  description      = "Finance users - Reader access only on the finance resource group"
}

# --- Example least-privilege RBAC assignment ---
# Finance group gets Reader (not Contributor/Owner) on a resource group.
data "azurerm_resource_group" "finance" {
  name = var.finance_resource_group_name
}

resource "azurerm_role_assignment" "finance_reader" {
  scope                = data.azurerm_resource_group.finance.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.finance.object_id
}
