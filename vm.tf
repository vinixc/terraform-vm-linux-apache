resource "azurerm_linux_virtual_machine" "vm-aulainfra" {
  name                = "mvirtual-aulainfra"
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  location            = azurerm_resource_group.rg-aulainfra.location
  size                = "Standard_DS1_v2"
  
  network_interface_ids = [
    azurerm_network_interface.nic-aulainfra.id
  ]

  admin_username      = var.user
  admin_password      = var.password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name = "mydisk"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sa-aulainfra.primary_blob_endpoint
  }
  
}