# Create a resource group
resource "azurerm_resource_group" "jenkins" {
  name     = "prod-rg"
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "jenkins" {
  name                = "prod-vnet"
  address_space       = [var.network-vnet-cidr]
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Create a subnet
resource "azurerm_subnet" "jenkins" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefixes     = [var.network-subnet-cidr]
}

# Create a public IP address
resource "azurerm_public_ip" "jenkins" {
  name                = "jenkins-public-ip"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  allocation_method   = "Dynamic"
}

# Create a network security group
resource "azurerm_network_security_group" "jenkins" {
  name                = "jenkins-nsg"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Jenkins-ui"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}


# Create a virtual machine
resource "azurerm_virtual_machine" "jenkins" {
  name                  = "jenkins-vm"
  location              = azurerm_resource_group.jenkins.location
  resource_group_name   = azurerm_resource_group.jenkins.name
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  vm_size               = var.jenkins_vm_size

  storage_os_disk {
    name              = "jenkins-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jenkins-vm"
    admin_username = var.linux_admin_username
    admin_password = var.linux_admin_password

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

# Create a network interface
resource "azurerm_network_interface" "jenkins" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  ip_configuration {
    name                          = "jenkins-pip"
    subnet_id                     = azurerm_subnet.jenkins.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
  }
}

resource "azurerm_network_interface_security_group_association" "jenkins" {
  network_interface_id      = azurerm_network_interface.jenkins.id
  network_security_group_id = azurerm_network_security_group.jenkins.id
}


# Create a data disk for the Jenkins VM
resource "azurerm_managed_disk" "jenkins_data_disk" {
  name                 = "jenkins-data-disk"
  location             = azurerm_resource_group.jenkins.location
  resource_group_name  = azurerm_resource_group.jenkins.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"
}

# Attach the data disk to the Jenkins VM
resource "azurerm_virtual_machine_data_disk_attachment" "jenkins_data_disk" {
  managed_disk_id    = azurerm_managed_disk.jenkins_data_disk.id
  virtual_machine_id = azurerm_virtual_machine.jenkins.id
  lun                = 0
  caching            = "None"
  create_option      = "Attach"
}


# Output the public IP address of the Jenkins VM
output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins.ip_address
}
