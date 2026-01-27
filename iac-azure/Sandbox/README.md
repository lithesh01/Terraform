# Azure Infrastructure as Code (Terraform)

This repository management infrastructure for the Everstage platform on Azure using a modular, metadata-driven approach.

## 🏗️ Architecture Catalog

The following core resources are managed within this project:

### 🌐 Networking

- **Virtual Network (VNet)**: Provides a secure, isolated environment for all resources with custom routing and DNS.
- **Private Subnets**: Segmented address spaces for internal services, databases, and private communication.
- **Private Endpoints**: Enables secure, private access to PaaS services (ACR, PostgreSQL, KV) from within the VNet.

### 💻 Compute & Serverless

- **Linux Virtual Machines**: Compute instances equipped with System-Managed Identities for automated build and deployment tasks.
- **Container Apps**: A serverless platform for deploying microservices with built-in scaling and internal ingress.
- **Function Apps**: Event-driven serverless compute for background processing and utility tasks.

### 🗄️ Data & Storage

- **PostgreSQL Flexible Server**: A managed database service optimized for performance, integrated with VNet for security.
- **Redis Cache**: High-speed, in-memory caching layer to optimize application response times.
- **Storage Accounts**: Durable cloud storage for files, blobs, and static website hosting.

### 🛡️ Security & Delivery

- **Application Gateway**: Layer 7 load balancer providing SSL termination, path-based routing, and WAF protection.
- **Key Vault**: Secure repository for managing application secrets, encryption keys, and SSL certificates.
- **Azure Container Registry (ACR)**: Private registry for hosting and managing secure container images.
- **Front Door**: Global distribution and edge security layer for optimized content delivery.

## ⚙️ How it Works

### 1. Environment-Driven Configuration

The infrastructure is controlled via environment-specific YAML files in the `Main/` directory.

- `dev.yml`: Development environment configuration.
- `sandbox.yml`: Sandbox environment configuration.

These files manage deployment flags, instance counts, SKU sizes, and network prefixes, allowing for consistent deployments across different tiers.

### 2. Deployment Command

Use the `environment` variable to target a specific configuration:

```powershell
terraform init
terraform plan -var="environment=sandbox"
terraform apply -var="environment=dev"
```

### 3. Hybrid Naming Setup

The infrastructure supports a **Hybrid Naming Strategy** controlled by the `local.tf` file. This allows for flexibility between strict, manually defined names and scalable, automatically generated ones.

- **Explicit Custom Naming**: By setting `use_custom_*_names = true` in `local.tf`, resources will use the specific names defined in the environment YAML files (e.g., `sandbox.yml`). This is useful for environments requiring specific naming conventions (e.g., `evstg-redis-sandbox-ci-01`).
- **Dynamic Naming**: If set to `false`, names are automatically generated using a base name + index pattern (e.g., `vm-base-name-01`, `vm-base-name-02`). This is ideal for scaling resources without manually updating lists.

This logic ensures that critical resources like Key Vaults and Databases can optionally have stable, pre-determined names while compute resources can scale dynamically.

## 🔐 Operational Hardening

- **Identity-Based Access**: Build VMs utilize Managed Identities and RBAC (`AcrPush`) for secure, passwordless container image uploads.
- **Accidental Deletion Protection**: Critical state-holding resources (DBs, Storage, VNets) have `prevent_destroy = true` enabled globally.
- **Automated DNS & Identity**: Infrastructure logic dynamically resolves Entra ID (AAD) IDs and private DNS records based on the active Azure session.

## 📂 Project Structure

```text
├── Main/               # Orchestration and Environment Config
│   ├── main.tf         # Resource composition
│   ├── local.tf        # YAML parsing and transformation logic
│   ├── dev.yml         # Dev Environment metadata
│   └── sandbox.yml     # Sandbox Environment metadata
└── modules/            # Isolated, reusable resource modules
```
