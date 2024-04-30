locals {
  intercepted_mssql_managed_instance_configuration_map = {
    for key, c in local.pl_intercepted_network_security_group_configuration_map : key => merge(
      c, c.resource_type != "Microsoft.Sql/managedInstances" ? {} : {
        connectivity_settings = merge(
          c.connectivity_settings, {
            route_table_config = merge(
              try(c.connectivity_settings.route_table_config, {}), {
                tags = merge(
                  try(c.connectivity_settings.route_table_config.tags, {}), merge(
                    c.tags, {
                      hidden-title = "Route Table for Managed Instance ${c.name}"
                    }
                  )
                )
              }
            )

            virtual_network_config = merge(
              try(c.connectivity_settings.virtual_network_config, {}), {
                address_space = try(c.connectivity_settings.virtual_network_config.address_space, null) != null ? c.connectivity_settings.virtual_network_config.address_space : ["10.0.0.0/24"]
                tags = merge(
                  try(c.connectivity_settings.virtual_network_config.tags, {}), merge(
                    c.tags, {
                      hidden-title = "Virtual Network for Managed Instance ${c.name}"
                    }
                  )
                )
              }
            )

            sqlmi_subnet_config = merge(
              try(c.connectivity_settings.sqlmi_subnet_config, {}), {
                name_config = try(c.connectivity_settings.sqlmi_subnet_config.name_config, null) != null ? c.connectivity_settings.sqlmi_subnet_config.name_config : {
                  values = {
                    workload_name = c.name
                  }
                },
                address_prefixes = try(c.connectivity_settings.sqlmi_subnet_config.address_space, null) != null ? c.connectivity_settings.sqlmi_subnet_config.address_space : ["10.0.0.0/25"]
              }
            )

            private_endpoints = [
              for pep in c.connectivity_settings.private_endpoints != null ? c.connectivity_settings.private_endpoints : [] : merge(
                pep, {
                  private_endpoint_config = merge(
                    pep.private_endpoint_config, {
                      tags = merge(
                        try(pep.private_endpoint_config.tags, {}), merge(
                          c.tags, {
                            hidden-title = "Private Endpoint for Managed Instance ${c.name}"
                          }
                        )
                      )
                    }
                  )
                }
              )
            ]
          }
        )
      }
    )
  }

  # intercepted_network_security_group_configuration_map = local.intercepted_network_security_group_configuration_map_route
}

