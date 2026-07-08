# CDEM01 — Data Platform Labs

Terraform infrastructure for a production-style AWS data platform. Each lab is an independent module with its own remote state changes to one never affect another.

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI >= 2.x, credentials configured via `aws configure`
- Default region is `us-east-1` — override with `-var "aws_region=<region>"` if needed

## Structure

```
CDEM01/
├── bootstrap/          
├── lab-1.1-iam/        
│   └── modules/
│       └── iam-role/  
└── lab-1.2-vpc/        
```

## Bootstrap

Provisions the S3 bucket all labs use for remote state. Uses local state intentionally, it is the state infrastructure. Run this once before any lab.

> **Run bootstrap first.** Skipping this will cause `terraform init` to fail in every lab — the S3 backend won't exist yet.

```bash
cd bootstrap
terraform init
terraform apply
```

Copy the `github_actions_role_arn` output and add it as a repository secret:

> GitHub → Settings → Secrets and variables → Actions → `AWS_OIDC_ROLE_ARN`

## Labs

### Lab 1.1 — IAM

IAM roles scoped per service- no shared, overly permissive roles across the platform.

| Role / Policy | Purpose |
|---|---|
| `DataEngineerRole` | S3, Glue, Redshift, EMR, Kinesis, Lambda, CloudWatch |
| `GlueServiceRole` | Assumed by Glue during ETL jobs |
| `LambdaExecutionRole` | Assumed by Lambda functions at runtime |
| `RedshiftIAMRole` | Allows Redshift to load data from S3 via COPY |
| `AnalystReadOnlyRole` | Read-only access via Athena, Redshift, QuickSight, and S3 |
| `DataLakeBucketAccessPolicy` | Enforces encryption on all `data-lake-*` buckets |

**Manually:**
```bash
cd lab-1.1-iam
terraform init
terraform plan
terraform apply
```

**Via GitHub Actions:** push to `main` or open a PR — the workflow runs `plan` automatically. To apply, go to Actions → `Lab 1.1 - IAM Setup` → Run workflow → select `apply`.

### Lab 1.2 — VPC

Multi-tier network across two availability zones — public subnet for the NAT Gateway, two private subnets for databases and compute. Private resources reach AWS services through VPC endpoints without traversing the internet.

| Resource | Details |
|---|---|
| VPC | `10.0.0.0/16` |
| Public subnet | `10.0.1.0/24` — us-east-1a |
| Private subnet 1 (databases) | `10.0.2.0/24` — us-east-1a |
| Private subnet 2 (compute) | `10.0.3.0/24` — us-east-1b |
| Internet Gateway | Routes public subnet traffic to the internet |
| NAT Gateway | Outbound internet access for private subnets |

**Manually:**
```bash
cd lab-1.2-vpc
terraform init
terraform plan
terraform apply
```

**Via GitHub Actions:** push or PR triggers a plan. For apply or destroy, go to Actions → `Lab 1.2 - VPC & Network Setup` → Run workflow:

| Action | What it does |
|---|---|
| `plan` | Runs `terraform plan` only |
| `apply` | Applies all changes |
| `destroy-nat-only` | Destroys only the NAT Gateway and its Elastic IP |
| `destroy-all` | Tears down the entire VPC |

> **Cost note:** The NAT Gateway charges by the hour even when idle. Run `destroy-nat-only` after the lab — no need to tear down the whole VPC.

## Remote State

All labs write state to the S3 bucket created by bootstrap:

| Lab | State Key |
|---|---|
| lab-1.1-iam | `lab1.1/iam/terraform.tfstate` |
| lab-1.2-vpc | `lab1.2/vpc/terraform.tfstate` |

Bucket: `cdem01-tfstate` · Region: `us-east-1` · Encrypted · Versioned
