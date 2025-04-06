# 🚀 N5 Terraform & Helmfile Multi-Stage Deployment on AKS

This project demonstrates a complete infrastructure and deployment pipeline on **Azure Kubernetes Service (AKS)** using:

- **Terraform** for provisioning infrastructure
- **Helm & Helmfile** for managing multi-environment Kubernetes deployments
- **Azure Container Registry (ACR)** for hosting a custom Docker image
- **Azure Key Vault** for securely managing secrets
- **GitHub Actions** for CI/CD automation

---

## 📁 Project Structure

N5-TEST/ ├── .github/workflows/ # CI/CD pipelines │ ├── apply.yml │ └── destroy.yml ├── chart/hello-chart/ # Helm chart for the app │ ├── templates/ │ │ └── deployment.yaml │ └── values.yaml ├── docker/ # Custom Docker image build │ ├── Dockerfile │ ├── generate-hello-plain-text-conf.sh │ └── hello-plain-text.conf.template ├── helmfiles/ │ └── helmfile.yaml # Helmfile with multi-stage support ├── terraform/aks/ # Terraform code for AKS, ACR, and infra │ ├── backend.tf │ ├── main.tf │ ├── outputs.tf │ ├── variables.tf │ └── terraform.tfvars ├── .gitignore └── README.md

---

## 🌐 What Does It Do?

It deploys a **custom NGINX-based app** that displays:

- The current environment (`dev` or `stage`)
- A secret value retrieved securely from **Azure Key Vault**

---

## 🧰 Technologies Used

| Tool            | Purpose                                |
|-----------------|----------------------------------------|
| Terraform       | AKS, ACR, RBAC, image build/push       |
| Docker          | Custom NGINX container build           |
| Azure Key Vault | Secure secret storage per environment  |
| Helm & Helmfile | App deployment to AKS per environment  |
| GitHub Actions  | Infrastructure + deployment automation |

---

## 🔐 GitHub Secrets Required

### `AZURE_CREDENTIALS`

Save the output of this command as a GitHub secret:

```bash
az ad sp create-for-rbac --name "terraform-sp" --sdk-auth
🚀 How to Use
1. Clone the repo
git clone https://github.com/your-username/n5-test.git
cd n5-aks-devops
2. Set the GitHub secret AZURE_CREDENTIALS
Add the full JSON output from the SP command as a secret in your repo: Settings → Secrets → Actions → New repository secret

3. Deploy Infrastructure & App
You can:

Push to main branch

This will:

✅ Provision ACR + AKS
✅ Build + push Docker image
✅ Deploy both dev and stage releases using Helmfile
✅ Inject secrets from Azure Key Vault using fetchSecretValue

4. Destroy Everything
Manually trigger the destroy.yml workflow to:

❌ Destroy AKS, ACR, namespaces, and Terraform state

🔧 Terraform Summary
Provisions:

Resource Group

AKS Cluster

ACR

Role assignment: AKS → ACR (AcrPull)

Builds the Docker image via null_resource with local-exec

📦 Docker Image
The image is based on nginxdemos/hello:plain-text:

Uses a startup script (entrypoint.d/) to substitute values in the NGINX config using env vars

Rendered values:

ENVIRONMENT

N5SECRET

These are injected at runtime via Kubernetes env: from Helmfile.

⚙️ Helmfile Behavior
Environments are defined like this:

environments:
  dev:
    values:
      - environment: "dev"
      - secrets:
          n5secret: ref+azurekeyvault://n5challenge/dev-n5challenge-secret

  stage:
    values:
      - environment: "stage"
      - secrets:
          n5secret: ref+azurekeyvault://n5challenge/stage-n5challenge-secret
The secret is injected into the container via:

env:
  - name: N5SECRET
    value: {{ .Environment.Values.secrets.n5secret | fetchSecretValue }}

---

✅ Requirements
Azure subscription

Azure CLI (az login)

Terraform CLI

Helm & Helmfile

Docker (if building locally)

👤 Author
Edwin Ernesto Rodriguez Duran