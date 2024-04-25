module "validate_custom_network_interface_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = try(local.resource_settings["Microsoft.Network/networkInterfaces"].naming.allowed_environments, local.global_settings.naming.allowed_environments)
    name_configs = [
      for c in local.pl_intercepted_tagging_configuration_map : merge(c.custom_network_interface_name_config, {
        tf_id         = c.tf_id,
        resource_type = "Microsoft.Network/networkInterfaces",
        parent_name   = c.name
      }) if try(c.custom_network_interface_name_config, null) != null
    ]
  }
}

locals {
  custom_network_interface_name_config_map = { for key, nc in module.validate_custom_network_interface_name_configs.validated_name_configs : key => {
    resource_abbreviation = local.resource_settings[nc.resource_type].naming.abbreviation,
    no_hypen = merge(
      local.global_settings.naming,
      local.resource_settings[nc.resource_type].naming
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  custom_network_interface_name_combination_map = {
    for key, nc in local.custom_network_interface_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  custom_network_interface_name_result_map = {
    for key, nc in local.custom_network_interface_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}
