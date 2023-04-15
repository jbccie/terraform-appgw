variable "resource_group_location" {
  default     = ["eastus","central us"]
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "jaskaran"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_name" {
 type = list(string)
default     = ["jaskaran", "singh", "Bahia"]
description = "create RG from the list"
}
## Variable with two resource group - example-rg1 and example-rg2
variable "resource_groups" {
  type = map(object({
    location = string
    tags     = map(string)
  }))
  default = {
    example-rg1 = {
      location = "eastus"
      tags = {
        environment = "dev"
      }
    },
    example-rg2 = {
      location = "westus"
      tags = {
        environment = "prod"
      }
    }
  }
}

# Variable with RG name,Location and sku defined statically.
variable "resource_configurations" {
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string
  }))
  default = {
    "VM-1" = {
      resource_group_name = "rg1"
      location            = "eastus"
      sku                 = "Standard"
    },
    "VM-2" = {
      resource_group_name = "rg2"
      location            = "westus"
      sku                 = "Basic"
    },
  }
}
variable "virtual_network_configurations" {
  type = map(object({
    name              = string
    address_space     = list(string)
    location          = string
    subnet_configurations = map(string)
  }))
  default = {
    "eastus" = {
      name              = "vnet-eastus"
      address_space     = ["10.0.0.0/16"]
      location          = "eastus"
      subnet_configurations = {
        "subnet1" = "10.0.1.0/24"
        "subnet2" = "10.0.2.0/24"
      }
      tags  = "DR"
    },
    "westus" = {
      name              = "vnet-westus"
      address_space     = ["10.1.0.0/16"]
      location          = "westus"
      subnet_configurations = {
        "subnet1" = "10.1.1.0/24"
        "subnet2" = "10.1.2.0/24"
      }
      tags  = "Prod"
    },
  }
}

##APPGW Variables

variable "regions" {
  type = map(string)
  default = {
    "eastus" = "East US"
    "centralus" = "Central US"
  }
}
variable "frontend_port_name" {
    default = "AGWFrontendPort"
}
variable "frontend_ip_configuration_name" {
    default = "AGWAGIPConfig"
}
variable "backend_address_pool_name" {
    default = "AGWBackendPool"
}
variable "http_setting_name" {
    default = "AGWHTTPsetting"
}
variable "listener_name" {
    default = "AGWListener"
}
variable "request_routing_rule_name" {
    default = "myRoutingRule"
}