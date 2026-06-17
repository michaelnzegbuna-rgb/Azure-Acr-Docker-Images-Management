# Containerized Application Deployment on Microsoft Azure: Registry, Image Publishing, and Service Validation

## Project Background

This repository documents the implementation of a cloud-based container deployment solution using Microsoft Azure services. The project includes application containerization with Docker, image storage within Azure Container Registry (ACR), deployment through Azure Container Instances (ACI), and verification of successful service execution.

---

# Requirement Coverage Summary

The following matrix demonstrates how each project objective has been addressed within the repository.

| Project Requirement              | Supporting Evidence                               | Repository Location                 |
| -------------------------------- | ------------------------------------------------- | ----------------------------------- |
| Container Registry Setup         | Registry creation and configuration details       | Cloud Registry Environment          |
| Image Packaging Process          | Docker image build instructions and configuration | Application Packaging Specification |
| Image Upload Confirmation        | Verification of successful image publication      | Registry Storage Verification       |
| Service Deployment Evidence      | Proof of active application availability          | Service Accessibility Assessment    |
| Governance and Security Controls | Version tracking and permission management        | Management and Security Practices   |

---

# Cloud Registry Environment

A dedicated Azure Container Registry was established to provide centralized storage and management for container images used throughout the deployment process.

### Registry Properties

| Parameter           | Configuration               |
| ------------------- | --------------------------- |
| Registry Identifier | learnacrnzemikez            |
| Service Level       | Basic                       |
| Hosting Location    | West Europe                 |
| Registry Address    | learnacrnzemikez.azurecr.io |
| Resource Collection | acr-learning-rg             |

The registry serves as the primary image repository and facilitates secure integration with Azure deployment services.

---

# Application Packaging Specification

To ensure portability and consistency across environments, the application was encapsulated within a Docker container based on a streamlined Python runtime image.

```dockerfile
# Base runtime image
FROM python:3.11-slim

# Define application directory
WORKDIR /app

# Transfer dependency file
COPY requirements.txt ./

# Install required packages
RUN pip install --no-cache-dir -r requirements.txt

# Transfer source code
COPY . .

# Open network port
EXPOSE 80

# Configure runtime settings
ENV FLASK_ENV=production
ENV PORT=80

# Start web service
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
```

### Packaging Workflow

The configuration above accomplishes the following:

* Utilizes a lightweight Python operating environment.
* Creates a dedicated workspace inside the container.
* Installs all required application dependencies.
* Copies project files into the image.
* Enables external access through port 80.
* Defines production runtime variables.
* Executes the application through Gunicorn.

---

# Build and Release Activities

## Local Container Platform Installation

Docker Desktop was installed to support image creation and testing on the local workstation.

```powershell
winget install Docker.DockerDesktop
```

## Authentication and Registry Connectivity

Access to Azure services and the container registry was established through Azure CLI authentication.

```bash
az login
az acr login --name learnacrnzemikez
```

## Image Generation

The application image was created locally and assigned a release tag for identification.

```bash
docker build -t learnacrnzemikez.azurecr.io/flask-acr-app:v4.0 .
```

## Registry Upload Operation

Following image creation, the artifact was uploaded to Azure Container Registry.

```bash
docker push learnacrnzemikez.azurecr.io/flask-acr-app:v4.0
```

## Container Service Provisioning

The published image was deployed to Azure Container Instances to provide a publicly accessible service.

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

# Registry Storage Verification

## Upload Confirmation

Successful execution of the image publication command confirmed that the container artifact was stored within the Azure Container Registry environment.

## Repository Evidence

The screenshot below demonstrates that the repository and associated version tag are visible within the Azure Portal.

```text
screenshots/azure_acr_portal.png
```

The repository listing should display the published image version `v4.0`.

---

# Service Accessibility Assessment

## Public Service Address

Upon successful deployment, Azure generated a public endpoint through which the application can be accessed.

**http://flaskacrdemo2026leye.westeurope.azurecontainer.io**

## Application Availability Proof

The following screenshot confirms that the web application is operational and responding successfully through its public URL.

```text
screenshots/web_app_live.png
```

This evidence verifies that the container instance was deployed correctly and remains accessible.

---

# Management and Security Practices

## Release Identification Strategy

A version-tagging methodology was implemented to maintain consistency across development, testing, and production deployments.

### Release Catalogue

| Image Version | Deployment Purpose                 |
| ------------- | ---------------------------------- |
| v1.0 – v3.0   | Experimental and validation builds |
| v4.0          | Final production deployment        |

### Operational Advantages

* Supports accurate release tracking.
* Simplifies rollback procedures when necessary.
* Protects production versions from accidental modification.
* Improves audit and change-management processes.

---

## Permission Governance Framework

Azure Role-Based Access Control (RBAC) was configured to ensure that registry operations adhere to the principle of least privilege.

### Image Retrieval Permissions

The AcrPull role grants read-only access for workloads and users that require container images without modification capabilities.

### Image Publishing Permissions

The AcrPush role allows authorized deployment accounts to upload, update, and maintain container images within the registry.

### Administrative Permissions

Owner and Contributor roles provide elevated access for resource administration, service configuration, and governance activities.

### Security Outcomes

* Restricts unauthorized changes to registry resources.
* Minimizes security risks through controlled access.
* Supports secure deployment automation.
* Enhances operational governance across Azure resources.

---

# Final Remarks

The successful completion of this project demonstrates practical knowledge of container lifecycle management within Microsoft Azure. Activities undertaken included image creation with Docker, image publication to Azure Container Registry, deployment through Azure Container Instances, validation of application availability, and implementation of access-control mechanisms to safeguard cloud resources. The supporting evidence confirms that all deployment objectives were completed successfully.
