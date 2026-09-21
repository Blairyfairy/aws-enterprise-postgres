# Enterprise AWS Infrastructure Repository

A production-ready, enterprise-grade Infrastructure as Code (IaC) repository using **Terraform** to provision a highly secure, multi-AZ, scalable AWS architecture. This setup includes a 3-tier Virtual Private Cloud (VPC), Application Load Balancer, Multi-AZ RDS PostgreSQL cluster, and a fully automated GitHub Actions CI/CD deployment pipeline.

---

## 🏗️ Architecture Overview

```text
       [ Internet / Clients ]
                 │
                 ▼
     [ Public Subnets (ALB) ]
                 │
                 ▼
    [ Private Subnets (App Tier) ]
                 │
                 ▼
   [ Database Subnets (Multi-AZ RDS) ]
```

* **VPC Isolation:** Spans 3 Availability Zones with strict separation between public, private, and database subnets.
* **High Availability:** Multi-AZ deployment for both compute layers and database instances, ensuring zero-downtime resilience and automated failover.
* **Security-First:** Least-privilege security groups, KMS storage encryption, and centralized secret management via AWS Secrets Manager.

---

## 📁 Repository Directory Structure

```text
aws-enterprise-infrastructure/
├── .github/
│   └── workflows/
│       └── terraform-ci-cd.yml      # Automated CI/CD pipeline (Plan on PR, Apply on Merge)
├── environments/
│   ├── production/
│   │   ├── backend.tf               # Remote backend (S3 + DynamoDB state locking)
│   │   ├── main.tf                  # Production environment configuration
│   │   └── terraform.tfvars         # Variable values for production
│   └── staging/
│       ├── backend.tf
│       ├── main.tf
│       └── terraform.tfvars
├── modules/
│   ├── alb/                         # Application Load Balancer & Target Groups
│   ├── database/                    # Multi-AZ RDS PostgreSQL with Secrets Manager integration
│   ├── security_groups/             # Least-privilege ingress/egress firewall rules
│   └── vpc/                         # 3-tier VPC (Public, Private, Database subnets + NAT Gateways)
├── .gitignore
└── README.md
```

---

## ⚙️ Prerequisites

Before working with this repository, ensure you have the following installed:
* **Terraform** (v1.8.0 or higher)
* **AWS CLI** (configured with appropriate administrative or deployment permissions)
* An existing **S3 Bucket** and **DynamoDB Table** configured for remote Terraform state management.

---

## 🚀 Getting Started Locally

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-org/aws-enterprise-infrastructure.git
   cd aws-enterprise-infrastructure/environments/production
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Preview the deployment plan:**
   ```bash
   terraform plan
   ```

4. **Apply the infrastructure:**
   ```bash
   terraform apply
   ```

---

## 🔄 CI/CD Automation (GitHub Actions)

This repository includes a pre-configured GitHub Actions pipeline (`.github/workflows/terraform-ci-cd.yml`) that automates infrastructure provisioning:
* **Pull Requests:** Automatically runs `terraform init`, `terraform validate`, and `terraform plan` to review infrastructure modifications safely.
* **Main Branch Merges:** Automatically executes `terraform apply -auto-approve` to deploy changes to the live production environment.
* **OIDC Security:** Connects securely to AWS without storing long-lived static credentials by leveraging GitHub OpenID Connect (OIDC) federation.