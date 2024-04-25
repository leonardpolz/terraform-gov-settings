
locals {
  configuration_map = {
    for c in var.configurations : c.tf_id => merge(
      jsondecode(c.resource_config_json), {
        tf_id         = c.tf_id,
        resource_type = c.resource_type
    })
  }
}

// Intercep Pipeline
locals {


  // Global Interceptors
  // ===================

  // 0 Configuration Input, main.tf
  pl_configuration_map = local.configuration_map

  // 1 Interceptor: Default Configuration, 1-interceptor.global.default-config.tf
  pl_intercepted_configuration_map = local.intercepted_default_configuration_map

  // 2 Interceptor: Naming, 2-interceptor.global.naming.tf
  pl_intercepted_naming_configuration_map = local.intercepted_naming_configuration_map

  // 3 Interceptor: Tagging, 3-interceptor.global.tagging.tf
  pl_intercepted_tagging_configuration_map = local.intercepted_tagging_configuration_map


  // Resource Specific Interceptors
  // ==============================

  // 4 Interceptor: Private Endpoint, 4-interceptor.private-endpoint.tf
  pl_intercepted_private_endpoint_configuration_map = local.intercepted_private_endpoint_configuration_map

  // 5 Interceptor: Virtual Network, 5-interceptor.virtual-network.tf
  pl_intercepted_virtual_network_configuration_map = local.intercepted_virtual_network_configuration_map


  // Final Configuration
  // =================== 

  intercepted_configuration_map = local.pl_intercepted_virtual_network_configuration_map
}
