provider "azurerm" {
version = "=2.20.0"
  features {}
}

# resource "azurerm_resource_group" "prodRG" {
#   name="prodRG"
#   location="East US"
# }
# resource "azurerm_virtual_network" "terraform" {
#   name="terraform"
#   location="East US"
#   address_space= ["10.0.0.0/16"]
#   resource_group_name = azurerm_resource_group.prodRG.name


# }