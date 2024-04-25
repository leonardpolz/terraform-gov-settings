module "validate_vnetp_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = (local.global_settings.naming.allowed_environments)
    name_configs = flatten([
      for c in local.pl_intercepted_private_endpoint_configuration_map : [
        for vnetp in c.virtual_network_peerings : merge(vnetp.name_config, {
          tf_id         = vnetp.tf_id,
          resource_type = "none",
          parent_name   = c.name
        })
      ] if try(c.virtual_network_peerings, null) != null
    ])
  }
}

locals {
  vnetp_name_config_map = { for key, nc in module.validate_vnetp_name_configs.validated_name_configs : key => {
    resource_abbreviation = "vnetp",
    no_hypen = merge(
      local.global_settings.naming,
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  vnetp_name_combination_map = {
    for key, nc in local.vnetp_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  vnetp_name_result_map = {
    for key, nc in local.vnetp_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}
