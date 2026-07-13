# network.tf
# Network layout:
#   - One VNet (10.0.0.0/16) containing two subnets
#   - Public subnet (10.0.0.0/24): hosts the app VM, reachable from internet
#   - Private subnet (10.0.1.0/24): hosts PostgreSQL, no internet exposure
# Separating app and DB into different subnets lets us apply different firewall (NSG) rules to each. 
# The DB only accepts traffic from the app subnet.

resource "azurerm_virtual_network" "main" {
  name                = "vnet-app-sea-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app-public"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db-private"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  # PostgreSQL Flexible Server with VNet integration requires a subnet
  # delegated exclusively to it so no other resource types can share it.
  delegation {
    name = "psql-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}




