# Azure Container Registry (ACR) and Docker Image Management Project

This repository contains the application source code, Docker configuration files, deployment procedures, and validation evidence developed as part of the Azure Container Registry (ACR) and Docker Image Management assignment.

---

## 📌 Assignment Deliverables Overview

The table below provides a clear mapping between the required assessment deliverables and their corresponding sections within this repository.

| Deliverable                     | Description                                                                        | Repository Section                                    |
| ------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------- |
| **Registry Information**        | Details of the Azure Container Registry, including its name and service tier       | [Registry Details](#1-registry-details)               |
| **Docker Configuration**        | Dockerfile used to build the container image                                       | [Dockerfile](#2-dockerfile)                           |
| **Deployment Validation**       | Evidence confirming the successful upload of the image to ACR                      | [Deployment Verification](#3-deployment-verification) |
| **Application Execution Proof** | Confirmation that the application is actively running in Azure Container Instances | [Proof of Execution](#4-proof-of-execution)           |
| **Project Documentation**       | Explanation of image versioning practices and Azure RBAC role assignments          | [Documentation](#5-documentation)                     |

---

## 1. Registry Details

The Azure Container Registry created for this project has the following configuration:

* **Registry Name:** `learnacrolamc`
* **Pricing Tier (SKU):** `Basic`
* **Deployment Region:** `West Europe`
* **Registry Endpoint:** `learnacrolamc.azurecr.io`
* **Resource Group:** `acr-learning-rg`

---

## 2. Dockerfile

The application is packaged into a container using a lightweight Python runtime image optimized for production environments. The Dockerfile performs the following operations:

* Uses Python 3.11 Slim as the base image.
* Creates `/app` as the working directory.
* Copies dependency definitions into the container.
* Installs all required packages.
* Transfers the application source code.
* Exposes port 80 for inbound traffic.
* Sets production environment variables.
* Starts the application using Gunicorn.

```dockerfile
# Use the official Python 3.11 slim image as the base image
FROM python:3.11-slim

# Configure the working directory
WORKDIR /app

# Copy dependency definitions
COPY requirements.txt ./

# Install required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose application port
EXPOSE 80

# Configure environment variables
ENV FLASK_ENV=production
ENV PORT=80

# Launch the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

---

## 3. Deployment Procedure

### Step 1: Install Docker Desktop

Install Docker Desktop using the command below:

```powershell
winget install Docker.DockerDesktop
```

Once installation is complete, start Docker Desktop to initialize the Docker Engine.

### Step 2: Authenticate with Azure

Sign in to Azure and authenticate against Azure Container Registry:

```bash
az login
az acr login --name learnacrolamc
```

### Step 3: Build the Container Image

Build the Docker image and assign the desired version tag:

```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### Step 4: Upload the Image to ACR

Push the image to Azure Container Registry:

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### Step 5: Deploy the Image to Azure Container Instances

Deploy the uploaded image as a container instance in Azure:

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

---

## 4. Deployment Verification

### Docker Push Confirmation

The successful completion of the `docker push` command confirms that the container image was uploaded to Azure Container Registry and registered under the `v4.0` tag.

### Registry Verification

A screenshot of the Azure Container Registry repository should be included to verify the presence of the uploaded image.

```text
screenshots/azure_acr_portal.png
```

---

## 5. Proof of Execution

### Live Application Endpoint

The application has been successfully deployed to Azure Container Instances and is accessible through the following URL:

**http://flaskacrdemo2026leye.westeurope.azurecontainer.io**

### Running Application Evidence

Include a screenshot of the running application to demonstrate successful deployment and accessibility.

```text
screenshots/web_app_live.png
```

---

## 6. Documentation

### Image Versioning Strategy

A semantic versioning approach was adopted to manage container image releases.

* **v1.0 – v3.0:** Development and testing releases.
* **v4.0:** Stable production deployment containing the completed Flask application.

#### Benefits of the Strategy

* **Consistency:** Released versions remain unchanged after deployment.
* **Traceability:** Each deployment can be linked to a specific build version.
* **Simplified Rollbacks:** Previous versions can be redeployed when necessary.
* **Controlled Releases:** Avoids risks associated with mutable tags such as `latest`.

### Azure RBAC Roles and Permissions

To maintain security and enforce least-privilege access, the following Azure RBAC roles were utilized:

#### AcrPull

Allows deployment services such as Azure Container Instances to download container images without modification permissions.

#### AcrPush

Enables CI/CD pipelines and deployment identities to upload and manage container images while restricting administrative access.

#### Owner / Contributor

Provides administrative permissions for registry management, resource provisioning, access control, and configuration updates.

---

## Project Summary

This project demonstrates the end-to-end process of container image management using Azure Container Registry, including image creation, version control, registry authentication, image deployment, validation, and secure access management through Azure RBAC.
