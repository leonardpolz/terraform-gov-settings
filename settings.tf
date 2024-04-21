locals {
  global_settings = {
    naming = {
      no_hypen = false
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
  }
}
