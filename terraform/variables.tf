variable "tenant_id" {
  description = "Entra ID tenant ID (lab tenant)"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID for RBAC assignments"
  type        = string
}

variable "break_glass_object_id" {
  description = "Object ID of the emergency-access account excluded from Conditional Access"
  type        = string
}

variable "finance_resource_group_name" {
  description = "Existing resource group on which the finance group gets Reader access"
  type        = string
  default     = "rg-finance-lab"
}

variable "ca_state" {
  description = "Conditional Access policy state: start in report-only, then enable"
  type        = string
  default     = "enabledForReportingButNotEnforced"
  validation {
    condition     = contains(["enabled", "disabled", "enabledForReportingButNotEnforced"], var.ca_state)
    error_message = "ca_state must be enabled, disabled, or enabledForReportingButNotEnforced."
  }
}
