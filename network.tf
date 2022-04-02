resource "azurerm_virtual_network" "vnet-aulainfra" {
  name                = "vnet"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
    turma = "FS04"
    faculdade = "Impacta"
    professor = "Joao"
  }
}

resource "azurerm_subnet" "subnet-aulainfra" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg-aulainfra.name
  virtual_network_name = azurerm_virtual_network.vnet-aulainfra.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "ip-aulainfra" {
  name                    = "public"
  location                = azurerm_resource_group.rg-aulainfra.location
  resource_group_name     = azurerm_resource_group.rg-aulainfra.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}


resource "azurerm_network_security_group" "nsg-aulainfra" {
  name                = "nsg"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic-aulainfra" {
  name                = "nic"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.subnet-aulainfra.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-aulainfra.id 
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-aulainfra" {
  network_interface_id      = azurerm_network_interface.nic-aulainfra.id
  network_security_group_id = azurerm_network_security_group.nsg-aulainfra.id
}

resource "azurerm_storage_account" "sa-aulainfra" {
  name                     = "storageaulainfra"
  resource_group_name      = azurerm_resource_group.rg-aulainfra.name
  location                 = azurerm_resource_group.rg-aulainfra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}


data "azurerm_public_ip" "ip-aulainfra-data" {
  name = azurerm_public_ip.ip-aulainfra.name
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
}
