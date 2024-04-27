module "validate_security_rule_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = local.global_settings.naming.allowed_environments
    name_configs = flatten([
      for c in local.pl_intercepted_route_table_configuration_map : [
        for sr in c.security_rules : merge(sr.name_config, {
          tf_id         = sr.tf_id,
          resource_type = "none",
          parent_name   = c.name
        })
      ] if try(c.security_rules, null) != null
    ])
  }
}

locals {
  security_rule_name_config_map = { for key, nc in module.validate_security_rule_name_configs.validated_name_configs : key => {
    resource_abbreviation = "sr"
    no_hypen = merge(
      local.global_settings.naming,
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  security_rule_name_combination_map = {
    for key, nc in local.security_rule_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  security_rule_name_result_map = {
    for key, nc in local.security_rule_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}


