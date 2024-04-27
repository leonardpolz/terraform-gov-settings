module "validate_route_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = local.global_settings.naming.allowed_environments
    name_configs = flatten([
      for c in local.pl_intercepted_virtual_network_configuration_map : [
        for r in c.routes : merge(r.name_config, {
          tf_id         = r.tf_id,
          resource_type = "none",
          parent_name   = c.name
        })
      ] if try(c.routes, null) != null
    ])
  }
}

locals {
  route_name_config_map = { for key, nc in module.validate_route_name_configs.validated_name_configs : key => {
    resource_abbreviation = "r"
    no_hypen = merge(
      local.global_settings.naming,
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  route_name_combination_map = {
    for key, nc in local.route_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  route_name_result_map = {
    for key, nc in local.route_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}
