#create a public IP address for the virtual machine
resource "azurerm_public_ip" "winnode3_pubip" {
  name                         = "winnode3_pubip"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "winnode3-${lower(substr("${join("", split(":", timestamp()))}", 8, -1))}"

  tags {
    environment = "${var.azure_env}"
  }
}

#create the network interface and put it on the proper vlan/subnet
resource "azurerm_network_interface" "winnode3_ip" {
  name                = "winnode3_ip"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "winnode3_ipconf"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.1.1.23"
    public_ip_address_id          = "${azurerm_public_ip.winnode3_pubip.id}"
  }
}

#create the actual VM
resource "azurerm_virtual_machine" "winnode3" {
  name                  = "winnode3"
  location              = "${var.azure_region}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.winnode3_ip.id}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "winnode3_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "winnode3"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
    custom_data    = "${file("./files/winrm.ps1")}"
  }

  tags {
    environment = "${var.azure_env}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    winrm = {
      protocol = "http"
    }
    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("./files/FirstLogonCommands.xml")}"
    }
  }

  connection {
    host     = "${azurerm_public_ip.winnode3_pubip.fqdn}"
    type     = "winrm"
    port     = 5985
    https    = false
    timeout  = "60m"
    user     = "${var.username}"
    password = "${var.password}"
  }

  provisioner "file" {
    source      = "files/Install-Habitat.ps1"
    destination = "c:/terraform/Install-Habitat.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "PowerShell.exe -ExecutionPolicy Bypass c:/terraform/Install-Habitat.ps1",
    ]
  }

  provisioner "file" {
    source      = "files/HabService.dll.3.config"
    destination = "C:/hab/svc/windows-service/HabService.dll.config"
  }

  provisioner "file" {
    source      = "files/Start-Habitat.ps1"
    destination = "c:/terraform/Start-Habitat.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "PowerShell.exe -ExecutionPolicy Bypass c:/terraform/Start-Habitat.ps1",
    ]
  }
}

output "node3" {
  value = "${azurerm_public_ip.winnode3_pubip.fqdn}"
}