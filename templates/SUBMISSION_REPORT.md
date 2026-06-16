# Assignment Report: Azure Container Registry (ACR) and Docker Container Management

This report outlines the design, implementation, verification, registry integration, and cloud deployment of the Flask-based Learning Dashboard using Azure Container Registry and Azure Container Instances.

---

## 1. Project Overview and Candidate Information

* **Student Name:** `[Your Name Here]`
* **Student ID / Matriculation Number:** `[Your Student ID Here]`
* **Project Title:** Azure Container Registry (ACR) and Docker Container Management
* **Course Module:** `[Course Code Here]`
* **Azure Deployment Region:** `West Europe`
* **Resource Group:** `acr-learning-rg`
* **Container Registry Name:** `learnacrolamc`
* **Container Registry Endpoint:** `learnacrnze.azurecr.io`
* **Container Instance Name:** `flask-acr-demo`
* **Application URL:** `http://flaskacrdemo2026nze.westeurope.azurecontainer.io`

---

## 2. Project Implementation Summary

The following activities were completed during the implementation phase:

### Application Enhancement

A critical import issue within the Flask application (`app.py`) was identified and corrected to ensure successful application execution.

### Deployment Script Optimization

PowerShell deployment scripts were reviewed and updated to resolve syntax-related issues, enabling reliable automation on Windows environments.

### Azure Container Instance Configuration

Deployment settings were updated to align with current Azure CLI requirements by explicitly defining:

* Operating System: Linux
* CPU Allocation: 1 vCPU
* Memory Allocation: 1 GB

### Validation and Testing

The complete deployment workflow, including image creation, registry upload, and cloud deployment, was successfully validated. The application was confirmed operational and capable of displaying real-time metrics such as uptime, CPU utilization, and memory consumption.

---

## 3. Evidence of Implementation and Deployment

### 3.1 Local Container Build Verification

**Objective:** Demonstrate successful local image creation and tagging.

**Required Evidence:**

* Successful execution of the Docker build command.
* Output of the `docker images` command showing the generated image.

**Screenshot File:**
`screenshots/local_docker_build.png`

![Local Docker Build Verification](screenshots/local_docker_build.png)

---

### 3.2 Azure Container Registry Validation

**Objective:** Verify that the container image has been successfully uploaded to Azure Container Registry.

**Required Evidence:**

* Registry repository listing.
* Presence of the `flask-acr-app` repository.
* Visibility of the `v4.0` image tag.

**Screenshot File:**
`screenshots/azure_acr_portal.png`

![Azure Container Registry Validation](screenshots/azure_acr_portal.png)

---

### 3.3 Azure Container Instance Deployment Verification

**Objective:** Confirm successful deployment of the containerized application.

**Required Evidence:**

* Running container status.
* Public FQDN.
* CPU and memory allocation details.

**Screenshot File:**
`screenshots/azure_aci_portal.png`

![Azure Container Instance Deployment Verification](screenshots/azure_aci_portal.png)

---

### 3.4 Application Availability Verification

**Objective:** Demonstrate that the deployed web application is accessible and functioning correctly.

**Required Evidence:**

* Browser view of the Flask dashboard.
* Display of uptime and system metrics.

**Screenshot File:**
`screenshots/web_app_live.png`

![Application Availability Verification](screenshots/web_app_live.png)

---

## 4. Technical Architecture and Design Analysis

### 4.1 Container Design and Dockerfile Optimization

The Dockerfile was designed using containerization best practices to maximize efficiency and maintainability.

#### Lightweight Runtime Environment

The project uses the `python:3.11-slim` base image, reducing overall image size while minimizing the operating system attack surface.

#### Layer Caching Optimization

Dependencies are installed before application files are copied into the image. This allows Docker to reuse cached dependency layers, significantly reducing rebuild times when source code changes.

#### Production-Ready Application Hosting

The application is served using Gunicorn instead of Flask’s development server, providing improved scalability, reliability, and production readiness.

---

### 4.2 Container Image Versioning Strategy

A semantic versioning approach was adopted to manage image releases.

#### Version History

* `v1.0` – Initial build release
* `v2.0` – Functional testing release
* `v3.0` – Validation and refinement release
* `v4.0` – Production deployment release

#### Benefits of Semantic Versioning

##### Release Stability

Published versions remain unchanged after deployment, ensuring consistency across environments.

##### Improved Change Tracking

Each image version can be associated with a specific development milestone or code revision.

##### Controlled Rollback Process

Previous versions can be redeployed quickly in the event of deployment issues.

##### Reduced Deployment Risk

Avoids dependence on mutable tags such as `latest`, preventing unintended production updates.

---

### 4.3 Azure Security and Access Management

The project applies the Principle of Least Privilege through Azure Role-Based Access Control (RBAC).

#### Owner / Contributor Role

Provides administrative permissions for managing Azure resources, registry configuration, and deployment settings.

#### AcrPush Role

Assigned to CI/CD services and deployment automation tools. This role permits image uploads while restricting broader administrative actions.

#### AcrPull Role

Assigned to Azure Container Instances to allow image retrieval without granting permissions to modify or delete registry resources.

This separation of duties enhances security and limits the impact of credential compromise.

---

## 5. Deployment Commands and Operational Procedures

### Azure Authentication and Registry Access

```bash
az login
az acr login --name learnacrolamc
```

### Container Image Build Process

```bash
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .
```

### Container Image Publication

```bash
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### Azure Container Instance Deployment

```bash
az container create \
    --resource-group acr-learning-rg \
    --name flask-acr-demo \
    --image learnacrolamc.azurecr.io/flask-acr-app:v4.0 \
    --dns-name-label flaskacrdemo2026nze \
    --ports 80 \
    --registry-username learnacrolamc \
    --registry-password "[REDACTED]" \
    --os-type Linux \
    --cpu 1 \
    --memory 1
```

---

## 6. Project Evaluation and Conclusion

This project successfully demonstrates the end-to-end lifecycle of containerized application deployment within Microsoft Azure. The implementation covers container image creation, optimization, registry management, cloud deployment, version control, security management, and operational verification.

The successful deployment of the Flask Learning Dashboard validates the effective use of Azure Container Registry (ACR), Azure Container Instances (ACI), Docker image management practices, and Azure RBAC security controls in a cloud-native environment.
