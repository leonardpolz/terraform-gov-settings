variable "tagging_config_validation" {
  type = object({
    tagging_configs = set(object({
      tf_id         = string
      resource_type = string
      tags          = map(string)
      parent_name   = optional(string)
    }))
  })

  validation {
    condition = alltrue([
      for tc in var.tagging_config_validation.tagging_configs : contains(keys(tc.tags), "terraform_repository_uri")
    ])
    error_message = "All tagging configs must contain a 'terraform_repository_uri' key"
  }

  validation {
    condition = alltrue([
      for tc in var.tagging_config_validation.tagging_configs : contains(keys(tc.tags), "deployed_by")
    ])
    error_message = "All tagging configs values must contain a 'deployed_by' key"
  }

  validation {
    condition = alltrue([
      for tc in var.tagging_config_validation.tagging_configs : contains(keys(tc.tags), "hidden-title")
    ])
    error_message = "All tagging configs values must contain a 'hidden-title' key"
  }

  default = {
    tagging_configs = []
  }
}

output "validated_tagging_configs" {
  value = { for tc in var.tagging_config_validation.tagging_configs : tc.tf_id => tc }
}
