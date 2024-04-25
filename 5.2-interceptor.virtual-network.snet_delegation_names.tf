module "validate_snet_delegation_name_configs" {
  source = "./validators"
  name_config_validation = {
    allowed_environments = local.global_settings.naming.allowed_environments
    name_configs = flatten([
      for c in local.pl_intercepted_private_endpoint_configuration_map : [
        for snet in c.subnets : [
          for index, del in snet.delegations : merge(snet.name_config, {
            tf_id         = "${snet.tf_id}_${index}",
            resource_type = "none",
            parent_name   = c.name
          })
        ] if try(snet.delegations, null) != null
      ] if try(c.subnets, null) != null
    ])
  }
}

locals {
  snet_delegation_name_config_map = { for key, nc in module.validate_snet_delegation_name_configs.validated_name_configs : key => {
    resource_abbreviation = "sdel",
    no_hypen = merge(
      local.global_settings.naming,
    ).no_hypen,
    workload_name = try(nc.values["workload_name"], "")
    }
  }

  snet_delegation_name_combination_map = {
    for key, nc in local.snet_delegation_name_config_map : key => {
      combination = [
        nc.resource_abbreviation,
        nc.workload_name,
      ]

      no_hypen = nc.no_hypen
    }
  }

  snet_delegation_name_result_map = {
    for key, nc in local.snet_delegation_name_combination_map : key => join(nc.no_hypen ? "" : "-", nc.combination)
  }
}
