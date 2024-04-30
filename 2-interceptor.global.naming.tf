module "validate_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = local.global_settings.naming.allowed_environments
    name_configs = [for c in local.pl_intercepted_configuration_map : merge(c.name_config, {
      tf_id         = c.tf_id,
      resource_type = c.resource_type
      parent_name   = c.parent_name
    }) if try(c.name_config, null) != null]
  }
}

locals {
  name_config_map = { for key, nc in module.validate_name_configs.validated_name_configs : key => {
    resource_type         = nc.resource_type,
    resource_abbreviation = local.resource_settings[nc.resource_type].naming.abbreviation,
    no_hypen = merge(
      local.global_settings.naming,
      local.resource_settings[nc.resource_type].naming
    ).no_hypen,
    environment   = try(nc.values["environment"], "")
    workload_name = try(nc.values["workload_name"], "")
    parent_name   = nc.parent_name
    }
  }

  default_name_combination_map = {
    for key, nc in local.name_config_map : key => {
      combination = [
        nc[try(local.resource_settings[nc.resource_type].naming.combination_order[0], local.global_settings.naming.combination_order[0])],
        nc[try(local.resource_settings[nc.resource_type].naming.combination_order[1], local.global_settings.naming.combination_order[1])],
        nc[try(local.resource_settings[nc.resource_type].naming.combination_order[2], local.global_settings.naming.combination_order[2])],
      ]

      no_hypen = nc.no_hypen
    } if nc.parent_name == null
  }

  parent_name_combination_map = {
    for key, nc in local.name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.parent_name,
      ]

      no_hypen = nc.no_hypen
    } if nc.parent_name != null
  }

  name_combination_map = merge(
    local.default_name_combination_map,
    local.parent_name_combination_map
  )

  name_result_map = {
    for key, nc in local.name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }

  intercepted_naming_configuration_map = {
    for key, c in local.pl_intercepted_configuration_map : key => merge(c, {
      name = contains(keys(c), "nc_bypass") ? (c.nc_bypass != null ? c.nc_bypass : local.name_result_map[c.tf_id]) : null,
    })
  }
}
