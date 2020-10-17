variable "prefix" {}
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.prodRG.name
  virtual_network_name = azurerm_virtual_network.terraform.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_resource_group" "prodRG" {
  name     = "prodRG"
  location = "East US"
}
resource "azurerm_virtual_network" "terraform" {
  name                = "terraform"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.prodRG.location
  resource_group_name = azurerm_resource_group.prodRG.name
}


resource "azurerm_network_interface" "vnic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.prodRG.location
  resource_group_name = azurerm_resource_group.prodRG.name

  ip_configuration {
    name                          = "terraformipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.prodRG.location
  resource_group_name   = azurerm_resource_group.prodRG.name
  network_interface_ids = [azurerm_network_interface.vnic.id]
  vm_size               = "Standard_DS2_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "ubuntuTestPublicIp1"
  resource_group_name = azurerm_resource_group.prodRG.name
  location            = azurerm_resource_group.prodRG.location
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "main2" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.prodRG.location
  resource_group_name   = azurerm_resource_group.prodRG.name
  network_interface_ids = [azurerm_network_interface.vnic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}