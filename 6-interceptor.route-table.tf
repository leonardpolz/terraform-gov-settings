locals {
  intercepted_route_table_configuration_map_route = {
    for key, c in local.pl_intercepted_virtual_network_configuration_map : key => merge(
      c, c.resource_type != "Microsoft.Network/routeTables" ? {} : {
        routes = [
          for r in c.routes != null ? c.routes : [] : merge(
            r, {
              name = r.nc_bypass != null ? r.nc_bypass : local.route_name_result_map[r.tf_id]
            }
          )
        ]
      }
    )
  }

  intercepted_route_table_configuration_map = local.intercepted_route_table_configuration_map_route
}

