locals {
  global_settings = {
    naming = {
      no_hypen             = false
      allowed_environments = ["dev", "qa", "prd"]
      combination_order    = ["resource_abbreviation", "environment", "workload_name"]
    }

    additional_tags = {
      provisioner = "terraform"
    }

    default_configuration = {
      location = "westeurope"
    }
  }

  resource_settings = {
    "Microsoft.Resources/resourceGroups" = {
      naming = {
        abbreviation = "rg"
      }

      additional_tags = {}

      default_configuration = {}
    },

    "Microsoft.Authorization/roleAssignments" = {
      default_configuration = {}
    }

    "Microsoft.KeyVault/vaults" = {
      naming = {
        abbreviation = "kv"
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Storage/storageAccounts" = {
      naming = {
        abbreviation = "st"
        no_hypen     = true
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Network/privateEndpoints" = {
      naming = {
        abbreviation = "pep"
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Network/virtualNetworks" = {
      naming = {
        abbreviation = "vnet"
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Network/virtualNetworks/subnets" = {
      naming = {
        abbreviation = "snet"
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Network/networkInterfaces" = {
      naming = {
        abbreviation = "nic"
      }

      additional_tags = {}

      default_configuration = {}
    }

    "Microsoft.Network/routeTables" = {
      naming = {
        abbreviation = "rt"
      }

      additional_tags = {}

      default_configuration = {}
    }
  }
}
