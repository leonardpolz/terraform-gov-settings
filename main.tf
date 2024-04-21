
locals {
  configuration_map = {
    for c in var.configurations : c.tf_id => merge(
      jsondecode(c.resource_config_json), {
        tf_id         = c.tf_id,
        resource_type = c.resource_type
    })
  }
}

locals {

  // Merge resource default configuration with resource configuration
  resource_default_configuration_map = {
    for key, c in local.configuration_map : key => merge(
      local.resource_settings[c.resource_type].default_configuration, {
        for key, v in c : key => v if v != null || try(local.resource_settings[c.resource_type].default_configuration[key], null) == null
      }
    )
  }

  // Merge global default configuration with resource default configuration
  global_default_configuration_map = {
    for key, c in local.resource_default_configuration_map : key => merge(
      local.global_settings.default_configuration, {
        for key, v in c : key => v if v != null || try(local.global_settings.default_configuration[key], null) == null
      }
    )
  }

  // Merge naming interceptor configuration and tagging interceptor configuration
  intercepted_configuration_map = {
    for key, c in local.global_default_configuration_map : key => merge(c, {
      // Inject modfied naming from naming-interceptor.tf
      name = contains(keys(c), "nc_bypass") ? (c.nc_bypass != null ? c.nc_bypass : local.name_result_map[c.tf_id]) : null,

      // Inject modfied tagging from tagging-interceptor.tf
      tags = contains(keys(c), "tags") ? local.tagging_result_map[c.tf_id] : null
    })
  }
}

