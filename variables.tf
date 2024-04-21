variable "configurations" {
  type = set(object({
    tf_id                = string
    resource_type        = string
    resource_config_json = string
  }))
}
