terraform {

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateandrew2026"
    container_name       = "tfstate-container"
    key                  = "dev.terraform.tfstate"
  }
}
