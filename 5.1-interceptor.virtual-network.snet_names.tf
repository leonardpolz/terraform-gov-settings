module "validate_snet_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = try(local.resource_settings["Microsoft.Network/virtualNetworks/subnets"].naming.allowed_environments, local.global_settings.naming.allowed_environments)
    name_configs = flatten([
      for c in local.pl_intercepted_private_endpoint_configuration_map : [
        for snet in c.subnets : merge(snet.name_config, {
          tf_id         = snet.tf_id,
          resource_type = "Microsoft.Network/virtualNetworks/subnets",
          parent_name   = c.name
        })
      ] if try(c.subnets, null) != null
    ])
  }
}

locals {
  snet_name_config_map = { for key, nc in module.validate_snet_name_configs.validated_name_configs : key => {
    resource_abbreviation = local.resource_settings[nc.resource_type].naming.abbreviation,
    no_hypen = merge(
      local.global_settings.naming,
      local.resource_settings[nc.resource_type].naming
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  snet_name_combination_map = {
    for key, nc in local.snet_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  snet_name_result_map = {
    for key, nc in local.snet_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}
