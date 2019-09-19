# Setup the infrastructure components required to create the environment

# Create a resource group to contain all the objects
resource "azurerm_resource_group" "rg" {
  name     = "${var.azure_rg_name}-${join("", split(":", timestamp()))}" #Removing the colons since Azure doesn't allow them.
  location = "${var.azure_region}"
}

# Create the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.azure_rg_name}_Network"
  address_space       = ["10.1.0.0/16"]
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

# Create the individual subnet for the servers
resource "azurerm_subnet" "subnet" {
  name                 = "${var.azure_rg_name}_Subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.1.0/24"
}

# create the network security group to allow inbound access to the servers
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.azure_rg_name}_nsg"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  # create a rule to allow HTTPS inbound to all nodes in the network
  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.source_address_prefix}"
    destination_address_prefix = "*"
  }

  # create a rule to allow HTTP inbound to all nodes in the network
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.source_address_prefix}"
    destination_address_prefix = "*"
  }

  # create a rule to allow RDP inbound to all nodes in the network. Note the priority. All rules but have a unique priority
  security_rule {
    name                       = "Allow_RDP"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.source_address_prefix}"
    destination_address_prefix = "*"
  }

  # create a rule to allow WinRM inbound to all nodes in the network. Note the priority. All rules but have a unique priority
  security_rule {
    name                       = "Allow_WinRM"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "${var.source_address_prefix}"
    destination_address_prefix = "*"
  }

  # create a rule to allow Butterfly inbound to all nodes in the network. Note the priority. All rules but have a unique priority
  security_rule {
    name                       = "Allow_Butterfly"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9631"
    source_address_prefix      = "${var.source_address_prefix}"
    destination_address_prefix = "*"
  }

  # add an environment tag.
  tags = {
    environment = "${var.azure_env}"
  }
}