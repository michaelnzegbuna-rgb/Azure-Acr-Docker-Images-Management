# Azure Container Registry and Container Lifecycle Management Report

## Project Summary

This project demonstrates the complete process of building, storing, publishing, and running a containerized web application using Microsoft Azure services. The implementation includes the creation of a Docker image, storage of the image within Azure Container Registry (ACR), deployment to Azure Container Instances (ACI), and verification that the application is accessible through a public endpoint.

---

# Assessment Coverage Matrix

The table below identifies where each assessment requirement is addressed within this repository.

| Requirement Area         | Evidence Provided                                    | Repository Section              |
| ------------------------ | ---------------------------------------------------- | ------------------------------- |
| Azure Registry Setup     | Registry configuration and deployment details        | Registry Environment Details    |
| Docker Image Creation    | Container build configuration and Dockerfile         | Image Creation Configuration    |
| Image Storage Validation | Registry upload and repository verification          | Registry Publication Evidence   |
| Container Deployment     | Running container instance and endpoint testing      | Service Availability Validation |
| Security and Governance  | Version control and access management implementation | Administrative Controls         |

---

# Registry Environment Details

An Azure Container Registry service was provisioned to serve as the centralized repository for container images used throughout this project.

### Registry Specifications

| Property            | Value                  |
| ------------------- | ---------------------- |
| Registry Identifier | learnacrnze            |
| Service Plan        | Basic                  |
| Hosting Region      | West Europe            |
| Registry Address    | learnacrnze.azurecr.io |
| Resource Container  | acr-learning-rg        |

The registry provides secure storage and distribution of container images while integrating seamlessly with other Azure services.

---

# Image Creation Configuration

The application was packaged into a Docker container using a Python-based runtime environment designed for efficiency and portability.

### Container Definition File

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 80

ENV FLASK_ENV=production
ENV PORT=80

CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

### Container Build Overview

The Docker configuration performs the following actions:

* Retrieves a lightweight Python runtime image.
* Establishes a working directory within the container.
* Installs all application dependencies.
* Transfers project files into the container image.
* Opens network port 80 for external communication.
* Defines environment settings for production execution.
* Launches the Flask application through Gunicorn.

---

# Container Publication Workflow

The following stages were completed to build and publish the application image.

## Installing the Docker Platform

Docker Desktop was installed to enable local container creation and testing.

```powershell
winget install Docker.DockerDesktop
```

## Connecting to Microsoft Azure

Authentication was completed through Azure CLI before accessing the container registry.

```bash
az login
az acr login --name learnacrnze
```

## Building the Container Image

A container image was generated and assigned a version-specific tag.

```bash
docker build -t learnacrnze.azurecr.io/flask-acr-app:v4.0 .
```

## Uploading the Image to Azure Container Registry

The completed image was transferred to the registry repository.

```bash
docker push learnacrnze.azurecr.io/flask-acr-app:v4.0
```

## Provisioning an Azure Container Instance

After publication, the image was deployed as a running Azure Container Instance.

```bash
az container create \
  --resource-group acr-learning-rg \
  --name flask-acr-demo \
  --image learnacrnze.azurecr.io/flask-acr-app:v4.0 \
  --dns-name-label flaskacrdemo2026nze \
  --ports 80 \
  --registry-username learnacrnze \
  --registry-password "<registry-password>" \
  --os-type Linux \
  --cpu 1 \
  --memory 1
```

---

# Registry Publication Evidence

## Confirmation of Image Upload

Successful execution of the push command verified that the container image was uploaded to Azure Container Registry without errors.

```bash
docker push learnacrnze.azurecr.io/flask-acr-app:v4.0
```

## Repository Verification

A screenshot captured from the Azure Portal confirms the presence of the repository and associated image tag within the registry.

**Evidence File:** `screenshots/azure_acr_portal.png`

---

# Service Availability Validation

## Public Access Endpoint

Following deployment, the application became available through the Azure-generated DNS endpoint:

```text
http://flaskacrdemo2026leye.westeurope.azurecontainer.io
```

## Operational Verification

Application functionality was tested by accessing the public endpoint through a web browser. The successful response confirms that the container instance is operating correctly.

**Evidence File:** `screenshots/web_app_live.png`

---

# Administrative Controls and Best Practices

## Image Release Management

Container versions are managed using a structured tagging approach to simplify deployment tracking and rollback procedures.

### Release Timeline

| Version Tag | Purpose                              |
| ----------- | ------------------------------------ |
| v1.0 - v3.0 | Development, testing, and validation |
| v4.0        | Production-ready release             |

### Advantages of Version Tagging

* Facilitates deployment tracking.
* Supports rollback to previous stable versions.
* Prevents accidental overwriting of production releases.
* Improves auditability throughout the deployment lifecycle.

---

## Access Management Strategy

Role-Based Access Control (RBAC) was applied to regulate permissions within the Azure environment.

### Registry Reader Permissions

The AcrPull role was assigned to identities requiring image download access.

### Registry Publisher Permissions

The AcrPush role was granted to accounts responsible for uploading and updating container images.

### Resource Administration Permissions

Owner and Contributor roles were used for resource deployment, service management, and permission assignment activities.

### Security Benefits

* Restricts access according to operational requirements.
* Reduces security exposure through least-privilege principles.
* Enhances governance of cloud resources.
* Supports secure and controlled deployment workflows.

---

# Project Outcome

This implementation successfully demonstrates the end-to-end lifecycle of containerized application management within Azure. The project covers image creation, registry storage, container deployment, service validation, version management, and access control implementation. Verification results confirm that the application image was successfully published, deployed, and made available through a publicly accessible Azure-hosted endpoint.
