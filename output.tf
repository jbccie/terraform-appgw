#output "resource_group_name" {
 # value = azurerm_resource_group.example[1].name
#}


# output "all_values_created_resource_group_location" {
 
#  value = values(azurerm_resource_group.example)[*].location

# }
# output "all_values_created_resource_group_names" {
 
#  value = values(azurerm_resource_group.example)[*].name

# }
# output "all_created_resource_group_name" {
#  value = azurerm_resource_group.example
# }

# output "all_created_VMs" {
#  value = azurerm_virtual_network.example[*].name
# }

#output "all_AGW_id" {
 # value = azurerm_application_gateway.main[*].id
 #}

 output "all_AGW_name" {
  value = values(azurerm_application_gateway.main)[*].name
 }
 output "all_AGW_frontend_ip_configuration" {
  value = values(azurerm_application_gateway.main)[*].frontend_ip_configuration
 }