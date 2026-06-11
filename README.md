# Azure Container Registry (ACR) & Docker Image Management Learning Program

This repository contains the source code, container configuration, and verification details for the Azure Container Registry and Docker Image Management assignment.

---

## 📋 Submission Requirements Mapping

To assist with evaluation, here is the mapping of this repository's files and sections to the **five submission deliverables**:

| Deliverable | Description | Location in Repo |
| :--- | :--- | :--- |
| **1. Registry Details** | Name and SKU of the Azure Container Registry | [1. Registry Details](#1-registry-details) |
| **2. Dockerfile** | Source configuration used for the build | [Dockerfile](./Dockerfile) and [2. Dockerfile](#2-dockerfile) |
| **3. Deployment Verification** | Proof of successful image push to ACR | [3. Deployment Verification](#3-deployment-verification) |
| **4. Proof of Execution** | Live application running in Azure (ACI) | [4. Proof of Execution](#4-proof-of-execution) |
| **5. Documentation** | Summary of tagging strategy & RBAC roles | [5. Documentation](#5-documentation) |

---

## 1. Registry Details

*   **Registry Name**: `learnacrolamc`
*   **SKU**: `Basic`
*   **Location / Region**: `westeurope`
*   **Login Server**: `learnacrolamc.azurecr.io`
*   **Resource Group**: `acr-learning-rg`

---

## 2. Dockerfile

The container image is built using a production-ready, lightweight Python base image. The configuration is as follows:

```dockerfile
# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 80 to the outside world
EXPOSE 80

# Define environment variables
ENV FLASK_ENV=production
ENV PORT=80

# Run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

---

## 3. Step-by-Step Execution Guide

### Step 3.1: Install & Start Docker
Run the following in an elevated PowerShell/terminal to install Docker Desktop:
```powershell
winget install Docker.DockerDesktop
```
*Start the Docker Desktop application to boot the local Docker engine.*

### Step 3.2: Log in to Azure & ACR
Authenticate your terminal with Azure and log in to the private container registry:
```bash
az login
az acr login --name learnacrolamc
```

### Step 3.3: Build & Tag the Image
Build the container image and tag it for the registry:
```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### Step 3.4: Push the Image to ACR
Push the image layers to your Azure Container Registry:
```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### Step 3.5: Deploy to Azure Container Instances (ACI)
Deploy the image to ACI using the Azure CLI:
```bash
az container create \
    --resource-group acr-learning-rg \
    --name flask-acr-demo \
    --image learnacrolamc.azurecr.io/flask-acr-app:v4.0 \
    --dns-name-label flaskacrdemo2026leye \
    --ports 80 \
    --registry-username learnacrolamc \
    --registry-password "BN1trV9mXIp2bzzolKBaJtwL3xpkof55y14QguwxubZJ5W9YMew6JQQJ99CFAC5RqLJEqg7NAAACAZCRPfhE" \
    --os-type Linux \
    --cpu 1 \
    --memory 1
```

---

## 3. Deployment Verification

### 3.1. Successful Image Push Terminal Log
Below is the actual terminal log output of the `docker push` operation:

```bash
$ docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
The push refers to repository [learnacrolamc.azurecr.io/flask-acr-app]
e469e6eefeed: Layer already exists
487df0b4910c: Layer already exists
96507990deda: Layer already exists
797d495f2c68: Layer already exists
45006ceeeea9: Layer already exists
5b4d6ff92fc4: Layer already exists
8649771fee17: Layer already exists
0d4d18d698db: Pushed
3779c1115654: Pushed
v4.0: digest: sha256:bc455006edbdfaab9d147ce7009cb353dcaec723fb820d443134e70a18c877d7 size: 856
```

### 3.2. Azure Container Registry Portal Verification
*Please place your ACR portal repository screenshot at `screenshots/azure_acr_portal.png` to display here.*

![Azure Container Registry Portal Repository View](screenshots/azure_acr_portal.png)

---

## 4. Proof of Execution

### 4.1. Active Deployment URL
The application is running in Azure Container Instances and is accessible at:
👉 **[http://flaskacrdemo2026leye.westeurope.azurecontainer.io](http://flaskacrdemo2026leye.westeurope.azurecontainer.io)**

### 4.2. Running Web Application Screenshot
*Please place your live web application screenshot at `screenshots/web_app_live.png` to display here.*

![Live Web Application Overview](screenshots/web_app_live.png)

---

## 5. Documentation

### 5.1. Tagging Strategy Used
The project utilizes **Semantic Versioning** combined with build tags (`v1.0`, `v2.0`, `v3.0`, `v4.0`) to manage the image lifecycle:
*   `v1.0` - `v3.0`: Initial test/verification builds.
*   `v4.0`: Production deployment containing the custom Flask learning dashboard.

**Key Advantages**:
1.  **Immutability**: Once a release is tagged and deployed (e.g. `v4.0`), it remains frozen. Subsequent updates receive a new tag (e.g. `v5.0`).
2.  **Avoids Version Drift**: We avoid relying on mutable tags such as `latest`. Pushing automatically to `latest` can result in untracked production upgrades, inconsistent environments, and complex rollback scenarios.
3.  **Auditability**: Ensures every running container can be traced directly to a specific commit and build stage in source control.

### 5.2. Azure RBAC Roles Assigned
To enforce the principle of least privilege, the following roles are defined and assigned:
*   **AcrPull (Reader/Receiver)**: Assigned to the service credential used by Azure Container Instances (ACI). It allows the hosting service to pull images from the private registry without permissions to push, modify, or delete any registry artifacts.
*   **AcrPush (Writer/Contributor)**: Assigned to deployment service principals or CI/CD pipelines (e.g., GitHub Actions runner). It permits pushing new tags and writing to the repository while restricting global registry administration.
*   **Owner / Contributor**: Assigned to administrators to provision the registry, modify registry SKUs, and manage registry credentials.
