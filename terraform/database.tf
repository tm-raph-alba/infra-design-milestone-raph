# database.tf 

# Single managed PostgreSQL Flexible Server instance, with VNet integration.
# Only app subnet can reach it

# Sizing: B1ms burstable tier (1 vCPU, 2GB RAM) 

resource "azurerm_private_dns_zone" "postgres" {
    name                    = "capstone-raph.postgres.database.azure.com"
    resource_group_name     = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
    name                    = "psql-dns-link"
    resource_group_name     = azurerm_resource_group.main.name
    private_dns_zone_name   = azurerm_private_dns_zone.postgres.name
    virtual_network_id      = azurerm_virtual_network.main.id
}

resource "azurerm_postgresql_flexible_server" "main" {
    name                          = "psql-app-raph-001"
    resource_group_name           = azurerm_resource_group.main.name
    location                      = azurerm_resource_group.main.location

    version                       = "16"
    administrator_login           = "psqladmin"
    administrator_password        = var.db_admin_password

    sku_name                      = "B_Standard_B1ms"       # burstable tier, 1 vCPU, 2GB RAM
    storage_mb                    = 32768                   # 32GB

    public_network_access_enabled = false                   # no internet exposure, only reachable from app subnet
    delegated_subnet_id           = azurerm_subnet.db.id
    private_dns_zone_id           = azurerm_private_dns_zone.postgres.id

    zone                          = "1"                     # no HA (out of scope). single zone for cost savings
    depends_on                    = [azurerm_private_dns_zone_virtual_network_link.postgres]
}

output "postgres_fqdn" {
    value                         = azurerm_postgresql_flexible_server.main.fqdn
}