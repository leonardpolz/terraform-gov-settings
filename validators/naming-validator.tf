variable "name_config_validation" {
  type = object({
    allowed_environments = set(string)
    name_configs = set(object({
      tf_id         = string
      resource_type = string
      values        = map(string)
      parent_name   = optional(string)
    }))
  })

  // Validate that all name_configs contain a 'workload_name' key
  validation {
    condition = alltrue([
      for nc in var.name_config_validation.name_configs : nc.parent_name != null || (contains(keys(nc.values), "workload_name") && can(regex("^[a-z0-9]+$", nc.values.workload_name)))
    ])
    error_message = "Every name_configs value must contain a 'workload_name' key that is lowercase alphanumeric"
  }

  // Validate that all name_configs contain an 'environment' key
  validation {
    condition = alltrue([
      for nc in var.name_config_validation.name_configs : nc.parent_name != null || (contains(keys(nc.values), "environment") && can(contains(var.name_config_validation.allowed_environments, nc.values.environment)))
    ])
    error_message = "Every name_configs value must contain an 'environment' key that is one of ${join(", ", var.name_config_validation.allowed_environments)}"
  }

  // Validate that all name_configs contain an 'id' key that is lowercase alphanumeric 
  validation {
    condition = alltrue([
      for nc in var.name_config_validation.name_configs : contains(keys(nc.values), "id") == false || can(regex("^[a-z0-9]+$", nc.values["id"]))
    ])
    error_message = "Every name_configs value that contains an 'id' key must be lowercase alphanumeric"
  }

  default = {
    allowed_environments = []
    name_configs         = []
  }
}

output "validated_name_configs" {
  value = { for nc in var.name_config_validation.name_configs : nc.tf_id => nc }
}
