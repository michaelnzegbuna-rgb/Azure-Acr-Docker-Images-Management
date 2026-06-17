# Azure Container Registry and Container Deployment Implementation Report

## Overview

This repository contains the resources, configuration files, deployment commands, and supporting evidence used to implement a containerized application on Microsoft Azure. The project demonstrates how Docker images can be created, stored within Azure Container Registry (ACR), and deployed to Azure Container Instances (ACI) for public access.

---

# Deliverables Traceability Matrix

The following table links each assessment requirement to the corresponding section of this repository.

| Assessment Component         | Evidence Provided                               | Section Reference                   |
| ---------------------------- | ----------------------------------------------- | ----------------------------------- |
| Registry Deployment          | Azure Container Registry configuration details  | Container Registry Details          |
| Image Build Process          | Docker image definition and build instructions  | Application Container Configuration |
| Registry Upload Verification | Confirmation of image storage within ACR        | Registry Validation                 |
| Running Service Validation   | Evidence of successful application deployment   | Application Accessibility Check     |
| Administrative Documentation | Version control and access management practices | Governance and Operations           |

---

# 1. Container Registry Details

To support centralized image management, an Azure Container Registry service was provisioned with the following specifications:

| Configuration Item | Value                       |
| ------------------ | --------------------------- |
| Registry Name      | learnacrnzemikez            |
| Service Plan       | Basic                       |
| Azure Region       | West Europe                 |
| Login Server       | learnacrnzemikez.azurecr.io |
| Resource Group     | acr-learning-rg             |

The registry acts as the primary repository for storing and distributing application container images throughout the deployment lifecycle.

---

# 2. Application Container Configuration

The application is packaged using Docker and executed within a lightweight Python environment designed for cloud-native workloads.

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 80

ENV FLASK_ENV=production
ENV PORT=80

CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

## Container Configuration Summary

The Dockerfile performs the following actions:

* Downloads a minimal Python runtime image.
* Creates an application workspace within the container.
* Installs project dependencies from the requirements file.
* Transfers application source code into the image.
* Opens network port 80 for incoming traffic.
* Defines production-specific environment variables.
* Starts the application using the Gunicorn web server.

---

# 3. Build and Release Workflow

## Docker Installation

Docker Desktop was installed to provide local containerization capabilities.

```powershell
winget install Docker.DockerDesktop
```

## Azure Authentication

The Azure CLI was used to authenticate and establish access to the container registry.

```bash
az login
az acr login --name learnacrnzemikez
```

## Image Build Procedure

The application image was built locally and assigned a version identifier.

```bash
docker build -t learnacrnzemikez.azurecr.io/flask-acr-app:v4.0 .
```

## Publishing the Image

Once the build completed successfully, the image was uploaded to Azure Container Registry.

```bash
docker push learnacrnzemikez.azurecr.io/flask-acr-app:v4.0
```

## Deploying to Azure Container Instances

The container image was deployed as a managed Azure Container Instance using the following command:

```bash
az container create \
  --resource-group acr-learning-rg \
  --name flask-acr-demo \
  --image learnacrnzemikez.azurecr.io/flask-acr-app:v4.0 \
  --dns-name-label flaskacrdemo2026leye \
  --ports 80 \
  --registry-username learnacrnzemikez \
  --registry-password "<registry-password>" \
  --os-type Linux \
  --cpu 1 \
  --memory 1
```

---

# 4. Registry Validation

## Image Publication Confirmation

Successful execution of the image upload process verified that the container artifact was stored within Azure Container Registry and became available for deployment.

## Registry Repository Evidence

The screenshot below provides proof that the repository and image version were successfully created within Azure Container Registry.

```text
screenshots/azure_acr_portal.png
```

The image tag `v4.0` should be visible within the repository listing.

---

# 5. Application Accessibility Check

## Service Endpoint

Following deployment, Azure assigned a public endpoint through which the application can be accessed.

```text
http://flaskacrdemo2026leye.westeurope.azurecontainer.io
```

## Runtime Verification

Application functionality was verified by accessing the public URL through a web browser and confirming that the service responded successfully.

```text
screenshots/web_app_live.png
```

This screenshot serves as evidence that the deployed container instance is operating correctly.

---

# 6. Governance and Operations

## Container Release Management

A structured image-tagging strategy was adopted to manage application releases throughout development and deployment activities.

### Release Record

| Version     | Purpose                            |
| ----------- | ---------------------------------- |
| v1.0 – v3.0 | Development and testing iterations |
| v4.0        | Approved production release        |

### Advantages

* Simplifies deployment tracking.
* Supports controlled rollback procedures.
* Prevents accidental overwriting of stable releases.
* Enhances auditability and change management.

---

## Access Control Implementation

Azure Role-Based Access Control (RBAC) was configured to regulate permissions and secure registry operations.

### AcrPull

Allows users and services to download container images without granting modification rights.

### AcrPush

Provides permission to upload, update, and manage container images within the registry.

### Owner and Contributor

Grants administrative capabilities required for resource provisioning, service configuration, and access management.

### Security Benefits

* Enforces least-privilege access principles.
* Protects registry resources from unauthorized modifications.
* Supports secure deployment automation.
* Improves governance across the Azure environment.

---

# Summary

The project successfully demonstrates an end-to-end container deployment workflow using Azure services. Activities completed include image creation with Docker, image storage in Azure Container Registry, deployment to Azure Container Instances, application validation through a public endpoint, and implementation of security controls using Azure RBAC. The accompanying screenshots and deployment evidence confirm the successful execution of all required tasks.
