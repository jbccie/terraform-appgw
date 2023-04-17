# resource "random_string" "rg" {
#   length  = 8
#   upper   = false
#   special = false
# }
terraform {
  required_version = ">=1.2"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "101-application-gateway"
   location = "eastus"
 }

resource "azurerm_virtual_network" "vnet" {
  for_each = var.regions
  name                = "myVNet-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = each.value
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  for_each = var.regions
  name                 = "myAGSubnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.21.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  for_each = var.regions
  name                 = "myBackendSubnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.21.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  for_each = var.regions
  name                = "myAGPublicIPAddress-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = each.value
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_application_gateway" "main" {
  for_each = var.regions  
  name                = "AppGateway-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = each.value

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend[each.key].id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 1
  }
}
# #Create two Nics
# resource "azurerm_network_interface" "nic0" {
#  for_each = var.regions  
#   name                = "nic-0"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "nic-ipconfig-0"
#     subnet_id                     = azurerm_subnet.backend[each.key].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_interface" "nic1" {
# for_each = var.regions  
#   name                = "nic-0"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "nic-ipconfig-0"
#     subnet_id                     = azurerm_subnet.backend[each.key].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc-0" {
#   for_each = var.regions
#   network_interface_id    = azurerm_network_interface.nic0[each.key].id
#   ip_configuration_name   = "nic-ipconfig-0"
#   backend_address_pool_id = one(azurerm_application_gateway.main[each.key].backend_address_pool).id
# }

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc-1" {
#   for_each = var.regions
#   network_interface_id    = azurerm_network_interface.nic1[each.key].id
#   ip_configuration_name   = "nic-ipconfig-1"
#   backend_address_pool_id = one(azurerm_application_gateway.main[each.key].backend_address_pool).id
# }
