module "validate_tagging" {
  source = "./validators"
  tagging_config_validation = {
    tagging_configs = [for c in local.configuration_map : {
      tf_id         = c.tf_id,
      resource_type = c.resource_type
      parent_name   = c.parent_name
      tags          = try(c.tags, null) != null ? c.tags : {}
    } if contains(keys(c), "tags")]
  }
}

locals {
  tagging_config_map = { for key, tc in module.validate_tagging.validated_tagging_configs : key => {
    additoinal_tags = merge(local.global_settings.additional_tags, local.resource_settings[tc.resource_type].additional_tags)

    tags = tc.tags
    }
  }

  tagging_result_map = {
    for key, tc in local.tagging_config_map : key => merge(tc.tags, tc.additoinal_tags)
  }
}


