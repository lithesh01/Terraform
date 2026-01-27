# GitHub Actions OIDC Setup Guide for Azure Terraform

This guide walks you through setting up **passwordless authentication** between GitHub Actions and Azure using Federated Credentials (OIDC).

## Overview

Instead of storing client secrets in GitHub, OIDC allows GitHub Actions to request short-lived tokens directly from Azure AD. This is more secure and eliminates secret rotation.

---

## Part 1: Azure Portal Configuration

### Step 1: Create/Verify App Registration

1. Go to **Azure Portal** → **Azure Active Directory** → **App registrations**
2. Find your existing app registration (e.g., `everstage-cicd-testing`)
3. Note down these values (you'll need them for GitHub):
   - **Application (client) ID**
   - **Directory (tenant) ID**
   - **Subscription ID** (from your Azure subscription)

### Step 2: Configure Federated Credentials

1. In your App Registration, go to **Certificates & secrets** → **Federated credentials** tab
2. Click **+ Add credential**
3. Select **GitHub Actions deploying Azure resources**
4. Fill in the details for **each environment**:

#### For Sandbox Environment:

```
Organization: <your-github-org>          # e.g., "Everstage"
Repository: <your-repo-name>             # e.g., "iac-azure"
Entity type: Environment
Environment name: sandbox
Name: github-sandbox-oidc
Description: GitHub Actions OIDC for sandbox environment
```

#### For Dev Environment:

```
Organization: <your-github-org>
Repository: <your-repo-name>
Entity type: Environment
Environment name: dev
Name: github-dev-oidc
Description: GitHub Actions OIDC for dev environment
```

#### For Production Environment:

```
Organization: <your-github-org>
Repository: <your-repo-name>
Entity type: Environment
Environment name: production
Name: github-production-oidc
Description: GitHub Actions OIDC for production environment
```

5. Click **Add** for each credential

### Step 3: Assign RBAC Permissions

Your service principal needs permissions to manage Azure resources:

1. Go to **Subscriptions** → Select your subscription
2. Click **Access control (IAM)** → **+ Add** → **Add role assignment**
3. Select role: **Contributor** (or more restrictive if needed)
4. Assign access to: **User, group, or service principal**
5. Select your app registration
6. Click **Review + assign**

---

## Part 2: GitHub Repository Configuration

### Step 1: Create Environments

1. Go to your GitHub repository
2. Navigate to **Settings** → **Environments**
3. Create three environments:
   - `sandbox`
   - `dev`
   - `production`

### Step 2: Configure Environment Variables

For **EACH environment** (sandbox, dev, production), add the following variables:

#### Go to: Settings → Environments → [environment-name] → Environment variables

**Azure Authentication Variables** (same for all environments):

```
AZURE_CLIENT_ID       = <Application (client) ID from Azure>
AZURE_TENANT_ID       = <Directory (tenant) ID from Azure>
AZURE_SUBSCRIPTION_ID = <Your Azure Subscription ID>
```

**Terraform Backend Variables** (specific to each environment):

For **sandbox**:

```
BACKEND_RESOURCE_GROUP  = <resource-group-name>      # e.g., "evstg-rg-sandbox-ci-01"
BACKEND_STORAGE_ACCOUNT = <storage-account-name>     # e.g., "evstgsandboxstg01"
BACKEND_CONTAINER       = <container-name>           # e.g., "tfstate"
BACKEND_KEY             = sandbox.tfstate
```

For **dev**:

```
BACKEND_RESOURCE_GROUP  = <resource-group-name>      # e.g., "evstg-rg-dev-ci-01"
BACKEND_STORAGE_ACCOUNT = <storage-account-name>     # e.g., "evstgdevstg01"
BACKEND_CONTAINER       = <container-name>           # e.g., "tfstate"
BACKEND_KEY             = dev.tfstate
```

For **production**:

```
BACKEND_RESOURCE_GROUP  = <resource-group-name>
BACKEND_STORAGE_ACCOUNT = <storage-account-name>
BACKEND_CONTAINER       = <container-name>
BACKEND_KEY             = production.tfstate
```

> [!IMPORTANT]
> **Storage Account Details**
>
> The storage account is where Terraform stores its state file. You need to create this in Azure first:
>
> 1. Create a Storage Account in each environment's resource group
> 2. Create a container named `tfstate` in each storage account
> 3. Use those names in the variables above

---

## Part 3: Testing the Setup

### Test the OIDC Connection

1. Go to **Actions** tab in your GitHub repository
2. Click **Terraform Deployment** workflow
3. Click **Run workflow**
4. Select:
   - Environment: `sandbox`
   - Terraform command: `plan`
5. Click **Run workflow**

### Expected Behavior

The workflow should:

1. ✅ Checkout code
2. ✅ Login to Azure using OIDC (no secrets!)
3. ✅ Show Azure account details
4. ✅ Initialize Terraform with remote backend
5. ✅ Run `terraform plan`

### Troubleshooting

#### Error: "AADSTS700016: Application not found"

- **Cause**: Client ID is incorrect
- **Fix**: Verify `AZURE_CLIENT_ID` matches your App Registration

#### Error: "No subscription found"

- **Cause**: Service principal doesn't have access
- **Fix**: Check RBAC permissions in Azure Portal

#### Error: "Failed to get existing workspaces"

- **Cause**: Backend storage account variables are incorrect
- **Fix**: Verify storage account name, container name, and resource group

#### Error: "The workflow is not requesting the 'id-token' permission"

- **Cause**: Missing permissions block in workflow
- **Fix**: Already added in the updated workflow file

---

## Part 4: What Changed in the Workflow

### Before (Client Secret):

```yaml
env:
  ARM_CLIENT_ID: ${{ secrets.AZURE_AD_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.AZURE_AD_CLIENT_SECRET }} # ❌ Secret stored
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.AZURE_AD_TENANT_ID }}
```

### After (OIDC):

```yaml
permissions:
  id-token: write # ✅ Required for OIDC
  contents: read

env:
  ARM_CLIENT_ID: ${{ vars.AZURE_CLIENT_ID }}
  ARM_SUBSCRIPTION_ID: ${{ vars.AZURE_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ vars.AZURE_TENANT_ID }}
  # ✅ No client secret needed!

steps:
  - name: Azure Login
    uses: azure/login@v1
    with:
      client-id: ${{ vars.AZURE_CLIENT_ID }}
      tenant-id: ${{ vars.AZURE_TENANT_ID }}
      subscription-id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
```

---

## Summary Checklist

### Azure Portal

- [ ] App Registration created
- [ ] Federated credentials added for each environment (sandbox, dev, production)
- [ ] RBAC permissions assigned (Contributor role)

### GitHub Repository

- [ ] Environments created (sandbox, dev, production)
- [ ] Azure variables added to each environment (CLIENT_ID, TENANT_ID, SUBSCRIPTION_ID)
- [ ] Backend variables added to each environment (RESOURCE_GROUP, STORAGE_ACCOUNT, CONTAINER, KEY)
- [ ] Storage accounts created in Azure with `tfstate` containers

### Testing

- [ ] Workflow runs successfully
- [ ] Azure login works without secrets
- [ ] Terraform initializes with remote backend
- [ ] Terraform plan executes

---

## Next Steps

After successful setup:

1. You can **delete** the old `AZURE_AD_CLIENT_SECRET` from GitHub secrets
2. The client secrets in Azure Portal can be removed (but keep one as backup initially)
3. Run `terraform apply` to deploy your infrastructure

## Questions?

If you encounter issues, check:

1. Federated credential entity type matches "Environment"
2. Environment names match exactly (case-sensitive)
3. Storage account is accessible and container exists
4. Service principal has proper permissions
