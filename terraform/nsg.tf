# nsg.tf 
# Two NSGs implementing security:
#   - nsg-app:  web open to public, SSH restricted to admin IP 
#   - nsg-db:   PostgreSQL port reachable ONLY from the app subnet, no internet exposure

resource "azurerm_network_security_group" "app" {
    name                = "nsg-app-public-raph"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow-https"
    priority                   = 100                   # high priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                 # HTTPS
    source_address_prefix      = "*"                   # users can come from anywhere
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"                  # HTTP
    source_address_prefix      = "*"                   # users can come from anywhere
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh-admin"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"                  # SSH
    source_address_prefix      = var.admin_source_ip   # staff door: admin only
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "db" {
    name                = "nsg-db-private-raph"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    security_rule {
    name                       = "allow-postgres-from-app"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/24"          # ONLY the app subnet
    destination_address_prefix = "*"
    }
}


# Attaching the NSGs to its respective subnet
resource "azurerm_subnet_network_security_group_association" "app" {
    subnet_id                 = azurerm_subnet.app.id
    network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
    subnet_id                 = azurerm_subnet.db.id
    network_security_group_id = azurerm_network_security_group.db.id
}