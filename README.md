# Azure Container Registry (ACR) and Docker Image Management: Deployment and Verification Report

This repository contains the application source code, container build configuration, deployment procedures, and validation evidence for the Azure Container Registry (ACR) and Docker Image Management assignment.

---

## 📋 Assessment Deliverables Overview

To support the evaluation process, the table below maps each assessment requirement to its corresponding section within this repository.

| Deliverable                       | Description                                       | Location in Repository        |
| --------------------------------- | ------------------------------------------------- | ----------------------------- |
| **Registry Configuration**        | Azure Container Registry details and service tier | Registry Configuration        |
| **Container Build Configuration** | Dockerfile used to create the container image     | Container Build Configuration |
| **Deployment Validation**         | Evidence of successful image publication to ACR   | Deployment Validation         |
| **Application Verification**      | Evidence of the running application in Azure      | Application Verification      |
| **Technical Documentation**       | Image versioning and Azure RBAC implementation    | Technical Documentation       |

---

## 1. Registry Configuration

* **Registry Name:** `learnacrolamc`
* **Service Tier (SKU):** `Basic`
* **Deployment Region:** `West Europe`
* **Registry Endpoint:** `learnacrolamc.azurecr.io`
* **Resource Group:** `acr-learning-rg`

---

## 2. Container Build Configuration

The application container image is built using a lightweight and production-ready Python runtime environment. The Dockerfile configuration is shown below:

```dockerfile
# Use the official Python runtime image
FROM python:3.11-slim

# Configure the working directory
WORKDIR /app

# Copy dependency definitions
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source files
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

## 3. Container Deployment Procedure

### 3.1 Docker Environment Setup

Install Docker Desktop using the following command:

```powershell
winget install Docker.DockerDesktop
```

### 3.2 Azure Authentication and Registry Access

Authenticate with Azure and connect to Azure Container Registry:

```bash
az login
az acr login --name learnacrolamc
```

### 3.3 Container Image Creation

Build and tag the Docker image:

```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### 3.4 Container Image Publication

Push the image to Azure Container Registry:

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### 3.5 Azure Container Instance Deployment

Deploy the container image to Azure Container Instances:

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

## 4. Deployment Validation

### 4.1 Container Image Upload Verification

The following output confirms the successful publication of the Docker image to Azure Container Registry.

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### 4.2 Azure Container Registry Verification

Include a screenshot showing the repository and image tag within Azure Container Registry.

![Azure Container Registry Repository View](screenshots/azure_acr_portal.png)

---

## 5. Application Verification

### 5.1 Application Endpoint Validation

The deployed application is available at:

**http://flaskacrdemo2026leye.westeurope.azurecontainer.io**

### 5.2 Running Application Evidence

Include a screenshot of the active application dashboard.

![Running Web Application](screenshots/web_app_live.png)

---

## 6. Technical Documentation

### 6.1 Container Image Versioning Strategy

The project adopts a semantic versioning approach to manage container image releases.

#### Version History

* `v1.0 – v3.0` : Development and testing releases
* `v4.0` : Production deployment release

#### Benefits

1. **Immutability** – Released versions remain unchanged after deployment.
2. **Version Consistency** – Prevents deployment issues caused by mutable tags such as `latest`.
3. **Traceability** – Every deployment can be linked to a specific application version and build process.

### 6.2 Azure Role-Based Access Control (RBAC)

The following Azure RBAC roles were implemented to enforce the Principle of Least Privilege:

#### AcrPull Role

Provides read-only access for services that require container image retrieval.

#### AcrPush Role

Allows deployment pipelines and service principals to publish and manage container images.

#### Owner / Contributor Roles

Provides administrative permissions for registry management, resource provisioning, and access control.
