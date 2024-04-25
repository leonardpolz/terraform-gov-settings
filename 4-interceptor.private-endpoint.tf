locals {
  intercepted_private_endpoint_configuration_map_strings = {
    for key, c in local.pl_intercepted_tagging_configuration_map : key => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        // Add custom_network_interface_name to the configuration, 4-interceptor.private-endpoint.custom_network_interface_name.tf
        custom_network_interface_name = c.custom_network_interface_nc_bypass != null ? c.custom_network_interface_nc_bypass : try(local.custom_network_interface_name_result_map[key], null)
      }
    )
  }

  intercepted_private_endpoint_configuration_map_private_dns_zone_group = {
    for key, c in local.intercepted_private_endpoint_configuration_map_strings : key => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        private_dns_zone_group = c.private_dns_zone_group == null ? null : merge(c.private_dns_zone_group, {
          name = c.private_dns_zone_group.nc_bypass != null ? c.private_dns_zone_group.nc_bypass : "pdzg-${c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map_private_service_connection = {
    for key, c in local.intercepted_private_endpoint_configuration_map_private_dns_zone_group : key => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        private_service_connection = c.private_service_connection == null ? null : merge(c.private_service_connection, {
          name = c.private_service_connection.nc_bypass != null ? c.private_service_connection.nc_bypass : "psc-${c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map_private_ip_configuration = {
    for key, c in local.intercepted_private_endpoint_configuration_map_private_service_connection : key => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        ip_configuration = c.ip_configuration == null ? null : merge(c.ip_configuration, {
          name = c.ip_configuration.nc_bypass != null ? c.ip_configuration.nc_bypass : "ipc-${c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map = local.intercepted_private_endpoint_configuration_map_private_ip_configuration
}
