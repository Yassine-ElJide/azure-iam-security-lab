# Conditional Access policies.
# Deployed in report-only first (var.ca_state) to avoid lockout, then enabled.
# The break-glass account is excluded from every policy.

# --- Require MFA for administrators ---
resource "azuread_conditional_access_policy" "mfa_admins" {
  display_name = "CA001 - Require MFA for admin roles"
  state        = var.ca_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_roles   = [
        "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
        "194ae4cb-b126-40b2-bd5b-6091b380977d", # Security Administrator
      ]
      excluded_users = [var.break_glass_object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

# --- Block legacy authentication ---
resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "CA002 - Block legacy authentication"
  state        = var.ca_state

  conditions {
    client_app_types = ["exchangeActiveSync", "other"] # legacy clients

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_users = [var.break_glass_object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}
