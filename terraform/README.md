# Terraform: Azure IAM lab

## Prerequisites
- A lab Entra ID tenant with Entra ID P1 or P2 (a P2 trial works) for Conditional Access
- An Azure subscription with a resource group `rg-finance-lab`
- `terraform >= 1.5`, `az cli` logged in to the lab tenant
- A **break-glass account** (cloud-only, excluded from CA). Create it first in the portal

## Run
```bash
az login --tenant <tenant-id>

terraform init
terraform plan  -var="tenant_id=<id>" -var="subscription_id=<id>" -var="break_glass_object_id=<id>"
terraform apply -var="tenant_id=<id>" -var="subscription_id=<id>" -var="break_glass_object_id=<id>"
```

## Safe rollout
1. `ca_state` defaults to **report-only**: policies log what they *would* block but don't enforce.
2. Review **Entra ID > Sign-in logs > Conditional Access** for a few days.
3. Re-apply with `-var="ca_state=enabled"` to enforce.

## Teardown
```bash
terraform destroy -var="tenant_id=<id>" -var="subscription_id=<id>" -var="break_glass_object_id=<id>"
```

> Never commit `terraform.tfstate` or `*.tfvars` with real IDs. They're in `.gitignore`.
