# vm.tf 

# Public IP the users connect to.
resource "azurerm_public_ip" "app" {
    name                                = "pip-app-raph-001"
    location                            = azurerm_resource_group.main.location
    resource_group_name                 = azurerm_resource_group.main.name
    allocation_method                   = "Static"                  # Static so it never changes across VM restarts
    sku                                 = "Standard"
}

# NIC - VM Network card
# Inside the app subnet and carries the public IP
resource "azurerm_network_interface" "app" {
    name                                = "nic-app-raph-001"
    location                            = azurerm_resource_group.main.location
    resource_group_name                 = azurerm_resource_group.main.name

    ip_configuration {
    name                                = "primary"
    subnet_id                           = azurerm_subnet.app.id
    private_ip_address_allocation       = "Dynamic"
    public_ip_address_id                = azurerm_public_ip.app.id
    }
}

# Sizing: Standard_B2s_v2 (2 vCPU, 8GB) burstable tier
# Suited for low-traffic site (<= 50 concurrent users)
resource "azurerm_linux_virtual_machine" "app" {
    name                                = "vm-app-raph-001"
    location                            = azurerm_resource_group.main.location
    resource_group_name                 = azurerm_resource_group.main.name
    size                                = "Standard_B2s_v2"
    admin_username                      = "azureadmin"
    network_interface_ids               = [azurerm_network_interface.app.id]

    admin_ssh_key {
        username                        = "azureadmin"
        public_key                      = file("~/.ssh/vm-capstone.pub")
    }

    os_disk {
        caching                         = "ReadWrite"
        storage_account_type            = "Standard_LRS"
    }

    source_image_reference {
        publisher                       = "Canonical"
        offer                           = "ubuntu-24_04-lts"
        sku                             = "server"
        version                         = "latest"
    }
}

output "vm_public_ip" {
    value                               = azurerm_public_ip.app.ip_address
}
