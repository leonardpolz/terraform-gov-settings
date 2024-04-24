locals {
  intercepted_resource_default_configuration_map = {
    for key, c in local.pl_configuration_map : key => merge(
      local.resource_settings[c.resource_type].default_configuration, {
        for key, v in c : key => v if v != null || try(local.resource_settings[c.resource_type].default_configuration[key], null) == null
      }
    )
  }

  intercepted_global_default_configuration_map = {
    for key, c in local.intercepted_resource_default_configuration_map : key => merge(
      local.global_settings.default_configuration, {
        for key, v in c : key => v if v != null || try(local.global_settings.default_configuration[key], null) == null
      }
    )
  }

  intercepted_default_configuration_map = local.intercepted_global_default_configuration_map
}
