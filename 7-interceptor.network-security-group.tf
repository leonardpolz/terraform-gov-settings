locals {
  intercepted_network_security_group_configuration_map_route = {
    for key, c in local.pl_intercepted_route_table_configuration_map : key => merge(
      c, c.resource_type != "Microsoft.Network/networkSecurityGroups" ? {} : {
        security_rules = [
          for sr in c.security_rules != null ? c.security_rules : [] : merge(
            sr, {
              name = sr.nc_bypass != null ? sr.nc_bypass : local.security_rule_name_result_map[sr.tf_id]
            }
          )
        ]
      }
    )
  }

  intercepted_network_security_group_configuration_map = local.intercepted_network_security_group_configuration_map_route
}
