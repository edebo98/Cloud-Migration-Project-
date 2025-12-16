# Copilot / AI Agent Instructions for this repository

Purpose: Short, actionable notes to help an AI agent be productive working on this Terraform-based AWS infra project.

## Big picture (what this repo creates)
- This is a small Terraform project that provisions AWS infra for a sample migration/WordPress stack:
  - VPC, public & private subnets, IGW and routing (`networking.tf`)
  - EC2 instance (`ec2.tf`) — AMI is hard-coded; instance type is provided via `var.instance_type`
  - RDS MySQL instance (`Rds.tf`) — private, 20GB, username/password come from variables
  - S3 bucket with public access blocked (`s3.tf`)
  - Security groups (`security.tf`) and IAM role/profile for EC2 (`IAM.tf`)
  - CloudWatch alarms for EC2 and RDS (`cloudwatch.tf`) and outputs (`outputs.tf`)

## Where to run Terraform (important, do not skip)
- Important discovery: some configuration files (provider, variables, tfvars) live under the `Terraform/` subdirectory, while resource files live at the repository root. Terraform evaluates only the .tf files in the current working directory.
- Immediate recommendation to avoid confusion:
  - Either consolidate all .tf files into a single directory (recommended), or run Terraform from the directory that contains *all* relevant files.
  - Example to run from the `Terraform` dir (PowerShell):

```powershell
cd "C:\Users\Edebo\Desktop\Project cloud engineering\Terraform"
terraform init
terraform validate
terraform fmt -recursive
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

- Or use `-chdir` to point at a directory: `terraform -chdir=Terraform plan -var-file=Terraform/terraform.tfvars` (be explicit about paths).

## Key conventions & project-specific patterns
- Variables are declared in `Terraform/Variables.tf` and instance values are provided via `Terraform/terraform.tfvars`.
- Sensitive variables: `db_password` is marked sensitive in `Variables.tf`, but the plaintext value exists in `terraform.tfvars` — treat this as a secret leakage risk and avoid committing real secrets.
- Naming: resources commonly use `migration-` and `wordpress-` prefixes in tags (see `networking.tf` and `ec2.tf`). Follow this pattern for new resources.
- No modules: project is not modularized — add new resources as separate `*.tf` files following existing top-level layout if you need to extend functionality.
- Security pattern: RDS is private (`publicly_accessible = false`) and the RDS security group allows MySQL only from the EC2 security group (see `security.tf`). Maintain that pattern when adding DB access rules.

## Integration points & external dependencies
- AWS provider configured in `Terraform/provider.tf` (provider reads `var.aws_region`).
- EC2 uses a region-specific hard-coded AMI ID (`ec2.tf`) — this must be updated when switching regions or replaced with a data source (e.g., `data "aws_ami"`) for portability.
- IAM: EC2 role has `AmazonS3ReadOnlyAccess` attached; the EC2 instance profile is attached in `ec2.tf`.

## Common developer workflows (clear, repeatable commands)
- Format and validate before a PR:
  - terraform fmt -recursive
  - terraform validate
- Plan & apply (PowerShell example):

```powershell
cd "path\to\Terraform"   # directory that contains provider.tf + variables
terraform init
terraform plan -var-file=terraform.tfvars
# review plan carefully for destructive changes (RDS has skip_final_snapshot = true)
terraform apply -var-file=terraform.tfvars
```

- To destroy test resources:

```powershell
terraform destroy -var-file=terraform.tfvars
```

- Useful outputs:
  - `terraform output ec2_public_ip` — returns EC2 public IP
  - `terraform output rds_endpoint` — returns RDS endpoint

## Safety notes & gotchas (from code review)
- RDS uses `skip_final_snapshot = true` — destructive; **be careful** running `apply`/`destroy` in non-test accounts.
- `db_password` is in `terraform.tfvars` in plaintext — remove secrets from repo and use a secret manager (discoverable in repo: `Terraform/terraform.tfvars`).
- Hard-coded AMI is region-specific and may not exist in other regions — prefer a data source or document required AMI per region.

## How to extend the project (practical tips for an agent)
- Follow existing naming/tagging conventions and split resources by functional responsibility (networking/security/compute/db).
- Add variables to `Terraform/Variables.tf` and provide defaults/values in `Terraform/terraform.tfvars` when appropriate.
- Run `terraform fmt` and `terraform validate` locally and include the plan output in PRs when possible.
- For RDS changes, prefer creating snapshots or turning off `skip_final_snapshot` in follow-up changes intended for production.

## Where to look for examples
- `networking.tf` — VPC, subnets, IGW, route table examples
- `ec2.tf` — EC2 configuration, SSH key usage, security group attachment
- `Rds.tf` — DB subnet group, DB instance parameters
- `IAM.tf` — IAM role/instance profile + policy attachment
- `cloudwatch.tf` — CloudWatch alarm definitions referencing other resources

---
If any part of this is unclear or you'd like the guidance to be stricter (e.g., enforce moduleization, add CI/format hooks, or sample `aws_ami` data source snippets), tell me which sections to expand and I will iterate. ✅
