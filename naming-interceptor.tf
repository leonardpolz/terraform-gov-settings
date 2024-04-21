module "validate_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = ["dev", "qa", "prd"]
    name_configs = [for c in local.configuration_map : merge(c.name_config, {
      tf_id         = c.tf_id,
      resource_type = c.resource_type
      parent_name   = c.parent_name
    }) if try(c.name_config, null) != null]
  }
}

locals {
  name_config_map = { for key, nc in module.validate_name_configs.validated_name_configs : key => {
    resource_abbreviation = local.resource_settings[nc.resource_type].naming.abbreviation,
    no_hypen = merge(
      local.global_settings.naming,
      local.resource_settings[nc.resource_type].naming
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], null)
    environment   = try(nc.values["environment"], null)
    id            = try(nc.values["id"], null)
    parent_name   = nc.parent_name != null ? replace(nc.parent_name, "-", "") : null
    }
  }

  default_name_combination_map = {
    for key, nc in local.name_config_map : key => {
      combination = concat([
        nc.resource_abbreviation,
        nc.workload_name,
        nc.environment,
      ], nc.id != null ? [nc.id] : [])

      no_hypen = nc.no_hypen
    } if nc.parent_name == null
  }

  parent_name_combination_map = {
    for key, nc in local.name_config_map : key => {
      combination = concat([
        nc.resource_abbreviation,
        nc.parent_name,
      ], nc.id != null ? [nc.id] : [])

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
}
