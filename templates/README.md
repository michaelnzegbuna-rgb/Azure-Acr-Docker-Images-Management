# Azure Container Registry (ACR) and Docker Image Management Project

This repository contains the application source code, Docker configuration files, deployment procedures, and validation evidence developed as part of the Azure Container Registry (ACR) and Docker Image Management assignment.

---

## 📌 Assessment Deliverables Overview

The table below provides a clear mapping between the required assessment deliverables and their corresponding sections within this repository.

| Deliverable                     | Description                                                                        | Repository Section                                                                  |
| ------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Registry Information**        | Details of the Azure Container Registry, including its name and service tier       | [Azure Container Registry Configuration](#1-azure-container-registry-configuration) |
| **Docker Configuration**        | Dockerfile used to build the container image                                       | [Container Build Configuration](#2-container-build-configuration)                   |
| **Deployment Validation**       | Evidence confirming the successful upload of the image to ACR                      | [Container Image Deployment Validation](#4-container-image-deployment-validation)   |
| **Application Execution Proof** | Confirmation that the application is actively running in Azure Container Instances | [Application Availability Verification](#5-application-availability-verification)   |
| **Project Documentation**       | Explanation of image versioning practices and Azure RBAC role assignments          | [Operational Documentation](#6-operational-documentation)                           |

---

## 1. Azure Container Registry Configuration

The Azure Container Registry created for this project has the following configuration:

* **Registry Name:** `learnacrolamc`
* **Pricing Tier (SKU):** `Basic`
* **Deployment Region:** `West Europe`
* **Registry Endpoint:** `learnacrolamc.azurecr.io`
* **Resource Group:** `acr-learning-rg`

---

## 2. Container Build Configuration

The application is packaged into a container using a lightweight Python runtime image optimized for production environments.

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

## 3. Container Build and Deployment Process

### Step 1: Docker Environment Setup

Install Docker Desktop and ensure the Docker Engine is running.

```powershell
winget install Docker.DockerDesktop
```

### Step 2: Azure Authentication and Registry Access

Authenticate with Azure and connect to Azure Container Registry.

```bash
az login
az acr login --name learnacrolamc
```

### Step 3: Container Image Creation

Build the Docker image and assign a version tag.

```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### Step 4: Container Image Publication

Push the Docker image to Azure Container Registry.

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### Step 5: Azure Container Instance Deployment

Deploy the containerized application to Azure Container Instances.

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

## 4. Container Image Deployment Validation

### Docker Push Verification

The successful completion of the Docker push operation confirms that the container image was uploaded to Azure Container Registry.

### Azure Container Registry Repository Verification

Include a screenshot showing the image repository and tag within Azure Container Registry.

```text
screenshots/azure_acr_portal.png
```

---

## 5. Application Availability Verification

### Deployed Application Endpoint

The application has been successfully deployed and is available through Azure Container Instances at:

**http://flaskacrdemo2026leye.westeurope.azurecontainer.io**

### Application Runtime Evidence

Include a screenshot of the running application to verify successful deployment and accessibility.

```text
screenshots/web_app_live.png
```

---

## 6. Operational Documentation

### Container Image Versioning Strategy

The project follows a semantic versioning approach for managing container image releases.

* **v1.0 – v3.0:** Development and testing builds.
* **v4.0:** Production-ready deployment release.

#### Benefits

* Release consistency through immutable version tags.
* Improved traceability across deployments.
* Easier rollback and recovery procedures.
* Better change management and release control.

### Azure Role-Based Access Control (RBAC) Implementation

The following Azure RBAC roles were used to maintain secure access management:

#### AcrPull Role

Allows deployment services to retrieve container images from the registry without modification permissions.

#### AcrPush Role

Allows CI/CD pipelines and deployment identities to publish and manage container images.

#### Owner / Contributor Roles

Provides administrative permissions for registry configuration, resource management, and access control.

---

## Project Conclusion

This project demonstrates the complete lifecycle of containerized application management in Azure, including container image creation, registry integration, deployment automation, validation procedures, and security management through Azure RBAC.
