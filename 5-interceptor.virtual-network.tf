locals {
  intercepted_virtual_network_configuration_map_snet = {
    for key, c in local.pl_intercepted_private_endpoint_configuration_map : key => merge(
      c, c.resource_type != "Microsoft.Network/virtualNetworks" ? {} : {
        subnets = {
          for snet in c.subnets != null ? c.subnets : [] : snet.tf_id => merge(
            snet, {
              name = snet.nc_bypass != null ? snet.nc_bypass : local.snet_name_result_map[snet.tf_id]

              delegations = [
                for index, del in snet.delegations != null ? snet.delegations : [] : merge(
                  del, {
                    name = del.nc_bypass != null ? del.nc_bypass : local.snet_delegation_name_result_map["${snet.tf_id}_${index}"]
                  }
                )
              ]

              network_security_group_settings = merge(
                snet.network_security_group_settings, {
                  tags = merge(
                    try(snet.network_security_group_settings.tags, null) != null ? snet.network_security_group_settings.tags : {}, merge(
                      c.tags, {
                        hidden-title = "Network Security Group for Subnet ${c.name}/${snet.nc_bypass != null ? snet.nc_bypass : local.snet_name_result_map[snet.tf_id]}"
                      }
                    )
                  )
                }
              )
            }
          )
        }
      }
    )
  }

  intercepted_virtual_network_configuration_map_vnetp = {
    for key, c in local.intercepted_virtual_network_configuration_map_snet : key => merge(
      c, c.resource_type != "Microsoft.Network/virtualNetworks" ? {} : {
        virtual_network_peerings = [
          for vnetp in c.virtual_network_peerings != null ? c.virtual_network_peerings : [] : merge(
            vnetp, {
              name = vnetp.nc_bypass != null ? vnetp.nc_bypass : local.vnetp_name_result_map[vnetp.tf_id]
            }
          )
        ]
      }
    )
  }

  intercepted_virtual_network_configuration_map = local.intercepted_virtual_network_configuration_map_vnetp
}
