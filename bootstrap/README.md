# Bootstrap — Terraform state backend

This is the one piece of Terraform in this repo that uses **local state**,
not remote. Its only job is to create the Storage Account that every other
configuration (`infra/`, `policies/`) uses as its remote backend — since that
backend doesn't exist yet, there's nowhere remote for bootstrap's own state
to live. Applied once; rarely touched again afterward.

## Applied backend details

These values are real, already-applied resources. Reference them exactly in
the `backend "azurerm"` block of every other Terraform configuration in this
repo:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-northwind-tfstate"
  storage_account_name = "stnorthwindtf676746"
  container_name       = "tfstate"
  key                  = "<config-name>.tfstate"   # unique per configuration
}
```

| Output | Value |
|---|---|
| Resource group | `rg-northwind-tfstate` |
| Storage account | `stnorthwindtf676746` |
| Container | `tfstate` |

## Why this resource group is separate from `rg-northwind-infra`

Different lifecycle. The main infrastructure (`infra/`) is destroyed and
recreated every practice session to control cost. This backend is meant to
persist indefinitely — destroying it while other configurations still
reference it as their remote state would orphan that state.

## Re-running this

This should rarely need to run again. If it ever does:

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```