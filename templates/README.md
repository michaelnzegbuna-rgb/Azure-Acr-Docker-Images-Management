# Azure Container Registry (ACR) & Docker Image Management Learning Program

This repository contains the source code, container configuration, deployment process, and verification evidence for the Azure Container Registry (ACR) and Docker Image Management assignment.

---

## 📋 Submission Requirements Mapping

To assist with evaluation, the table below maps each assignment deliverable to its corresponding section within this repository.

| Deliverable                    | Description                                                          | Location in Repository                                |
| ------------------------------ | -------------------------------------------------------------------- | ----------------------------------------------------- |
| **1. Registry Details**        | Azure Container Registry name, SKU, and configuration details        | [Registry Details](#1-registry-details)               |
| **2. Dockerfile**              | Container image build configuration                                  | [Dockerfile](#2-dockerfile)                           |
| **3. Deployment Verification** | Evidence of successful image push to Azure Container Registry        | [Deployment Verification](#3-deployment-verification) |
| **4. Proof of Execution**      | Verification of the running application in Azure Container Instances | [Proof of Execution](#4-proof-of-execution)           |
| **5. Documentation**           | Image tagging strategy and Azure RBAC role assignments               | [Documentation](#5-documentation)                     |

---

## 1. Registry Details

The Azure Container Registry used for this project is configured as follows:

* **Registry Name:** `learnacrolamc`
* **SKU:** `Basic`
* **Region:** `West Europe`
* **Login Server:** `learnacrolamc.azurecr.io`
* **Resource Group:** `acr-learning-rg`

---

## 2. Dockerfile

The application container is built using a lightweight, production-ready Python image. The Dockerfile configuration is shown below:

```dockerfile
# Use the official Python 3.11 slim image as the base image
FROM python:3.11-slim

# Set the application's working directory
WORKDIR /app

# Copy the dependency file to the container
COPY requirements.txt ./

# Install required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source files into the container
COPY . .

# Expose port 80 for external access
EXPOSE 80

# Configure environment variables
ENV FLASK_ENV=production
ENV PORT=80

# Launch the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

---

## 3. Step-by-Step Execution Guide

### Step 3.1: Install and Start Docker

Install Docker Desktop using the following command:

```powershell
winget install Docker.DockerDesktop
```

After installation, launch Docker Desktop to start the Docker Engine.

### Step 3.2: Authenticate with Azure and ACR

Sign in to Azure and authenticate with the Azure Container Registry:

```bash
az login
az acr login --name learnacrolamc
```

### Step 3.3: Build and Tag the Docker Image

Build the Docker image and assign a version tag:

```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### Step 3.4: Push the Image to Azure Container Registry

Upload the image to the registry:

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### Step 3.5: Deploy to Azure Container Instances (ACI)

Deploy the image to Azure Container Instances:

```bash
az container create \
    --resource-group acr-learning-rg \
    --name flask-acr-demo \
    --image learnacrolamc.azurecr.io/flask-acr-app:v4.0 \
    --dns-name-label flaskacrdemo2026leye \
    --ports 80 \
    --registry-username learnacrolamc \
    --registry-password "<registry-password>" \
    --os-type Linux \
    --cpu 1 \
    --memory 1
```

> **Security Note:** Never expose registry passwords or credentials in public repositories. Replace sensitive values with placeholders before publishing.

---

## 3. Deployment Verification

### 3.1 Successful Docker Push Operation

The following terminal output confirms the successful upload of the container image to Azure Container Registry:

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

### 3.2 Azure Container Registry Verification

Add a screenshot of the Azure Container Registry repository view to verify that the image exists in the registry.

```text
screenshots/azure_acr_portal.png
```

![Azure Container Registry Repository View](screenshots/azure_acr_portal.png)

---

## 4. Proof of Execution

### 4.1 Running Application URL

The deployed application is accessible through Azure Container Instances at:

**http://flaskacrdemo2026leye.westeurope.azurecontainer.io**

### 4.2 Running Application Screenshot

Add a screenshot demonstrating that the application is running successfully.

```text
screenshots/web_app_live.png
```

![Running Web Application](screenshots/web_app_live.png)

---

## 5. Documentation

### 5.1 Container Image Tagging Strategy

This project follows a semantic versioning approach for image management:

* **v1.0 – v3.0:** Development, testing, and validation releases.
* **v4.0:** Production-ready release containing the completed Flask dashboard application.

#### Benefits

1. **Immutability** – Released versions remain unchanged after deployment.
2. **Version Control** – Eliminates the risks associated with mutable tags such as `latest`.
3. **Traceability** – Every deployed image can be mapped to a specific build and source code version.
4. **Rollback Support** – Previous stable versions can be redeployed quickly if needed.

### 5.2 Azure RBAC Roles

The following Azure Role-Based Access Control (RBAC) roles are used to implement the principle of least privilege:

#### AcrPull

Assigned to Azure Container Instances (ACI) or other deployment targets. This role allows services to pull container images without permissions to modify or delete registry content.

#### AcrPush

Assigned to deployment service principals and CI/CD pipelines. This role allows users and services to push new images and manage repositories while restricting administrative actions.

#### Owner / Contributor

Assigned to administrators responsible for registry provisioning, configuration management, SKU changes, and access control.

---

## Conclusion

This project demonstrates the complete lifecycle of container image management using Azure Container Registry, including image creation, versioning, registry authentication, image deployment, verification, and secure access management through Azure RBAC.
