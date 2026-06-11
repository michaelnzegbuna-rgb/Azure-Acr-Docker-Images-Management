# Assignment Submission Report: Azure Container Registry & Docker Image Management

This report documents the implementation, local verification, registry upload, and cloud deployment of the Flask-based Learning Dashboard container.

---

## 1. Student & Project Information

*   **Student Name**: `[Your Name Here]`
*   **Student ID / Matric Number**: `[Your Student ID Here]`
*   **Assignment Title**: Azure Container Registry (ACR) & Docker Image Management Learning Program
*   **Course Code**: `[Course Code Here]`
*   **Deployment Region**: `westeurope`
*   **Resource Group**: `acr-learning-rg`
*   **ACR Registry Name**: `learnacrolamc`
*   **ACR Login Server**: `learnacrolamc.azurecr.io`
*   **ACI Instance Name**: `flask-acr-demo`
*   **Live Web App URL**: [http://flaskacrdemo2026leye.westeurope.azurecontainer.io](http://flaskacrdemo2026leye.westeurope.azurecontainer.io)

---

## 2. Executive Summary of Implementation

1.  **Code Correction**: Resolved a critical import error in the Flask application (`app.py`) where `render_code_template` was incorrectly imported.
2.  **Script Automation**: Resolved syntax parsing issues in the PowerShell deployment script (`deploy.ps1`) to enable seamless automation on Windows hosts.
3.  **Modern ACI Deployment**: Modified the Azure Container Instances creation parameters to explicitly declare `--os-type Linux`, `--cpu 1`, and `--memory 1` to comply with the latest Azure CLI resource requirements.
4.  **Verification**: Verified container build, push, and deployment successfully. The live website is running and dynamically reporting memory, CPU usage, and uptime.

---

## 3. Required Deliverable Screenshots

*Please take the following screenshots and save them into the `/screenshots` directory of this folder. The report links will render automatically in your Markdown viewer.*

### Screenshot 3.1: Local Docker Build & Image Verification
* **Description**: Shows the successful execution of the `docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .` command in the terminal.
* **Instruction**: Run `docker images` to show the tag listed on your local system, then take a screenshot of your terminal.
* **File Name**: `screenshots/local_docker_build.png`

![Local Docker Build & Image List](screenshots/local_docker_build.png)

---

### Screenshot 3.2: Azure Container Registry (ACR) Portal
* **Description**: Shows the Azure Portal view of the `learnacrolamc` container registry.
* **Instruction**: Navigate to **Azure Container Registry** -> **Repositories** -> **flask-acr-app** in the Azure Portal, highlighting the `v4.0` tag. Take a screenshot.
* **File Name**: `screenshots/azure_acr_portal.png`

![Azure Container Registry Tag View](screenshots/azure_acr_portal.png)

---

### Screenshot 3.3: Azure Container Instances (ACI) Portal
* **Description**: Shows the Azure Portal view of the running `flask-acr-demo` Container Instance.
* **Instruction**: Navigate to **Container Instances** -> **flask-acr-demo** -> **Overview** showing status **Running**, FQDN, and CPU/Memory limits. Take a screenshot.
* **File Name**: `screenshots/azure_aci_portal.png`

![Azure Container Instance Overview](screenshots/azure_aci_portal.png)

---

### Screenshot 3.4: Live Web Application Running
* **Description**: The active Flask web dashboard loaded in the browser showing live system uptime and metrics.
* **Instruction**: Open a web browser, navigate to `http://flaskacrdemo2026leye.westeurope.azurecontainer.io`, and take a screenshot of the page.
* **File Name**: `screenshots/web_app_live.png`

![Live Web App Dashboard](screenshots/web_app_live.png)

---

## 4. Key Concepts & Architecture Questions

### 4.1. Multi-Stage Dockerfile Layout & Advantages
Our `Dockerfile` utilizes a lightweight structure to package the Flask application:
*   **Base Image**: `python:3.11-slim` provides a minimal Debian package set which reduces the attack surface and overall image size (compared to the heavy default `python:3.11` image).
*   **Layer Caching**: `requirements.txt` is copied first and dependencies are installed *before* copying the source code. This ensures that modifications to the application code do not trigger a reinstall of dependencies, optimizing build speed.
*   **Production WSGI**: Runs using `gunicorn` on port `80`, avoiding the default Flask development server which is not designed for concurrent or high-traffic production workloads.

### 4.2. Image Tagging Strategy (Semantic Versioning vs. Mutable Tags)
*   **Strategy**: This program uses semantic versioning numbers (`v1.0`, `v2.0`, `v3.0`, `v4.0`) to tag images.
*   **Advantages**: 
    1.  **Immutability**: Once a release (e.g., `v4.0`) is built and tested, it is frozen. Pushing subsequent builds uses a new tag (e.g., `v5.0`).
    2.  **Safety**: Avoids relying on mutable tags like `latest` in production. If `latest` is updated automatically, it can lead to version drift, untested deployments, and difficulties in performing precise rollbacks.
    3.  **Traceability**: Every production container can be traced back to a specific git commit/version of the codebase.

### 4.3. Azure RBAC Access Control & Least Privilege
To secure the container lifecycle, we follow the principle of least privilege using three main Azure IAM/RBAC roles:
1.  **Owner / Contributor**: Grants full management of the registry and ACI container group (used by administrators).
2.  **AcrPush (Writer)**: Grants permission to push new layers and version tags. Assigned specifically to CI/CD service principals (e.g., GitHub Actions workflow) to prevent them from deleting or modifying other Azure infrastructure.
3.  **AcrPull (Reader)**: Grants read-only permission to retrieve image layers. Assigned to the Azure Container Instance (ACI) credential set. This ensures that even if the ACI container is compromised, it cannot write to, delete, or modify the container registry.

---

## 5. Implementation Commands Reference

### Build and Push Command Set
```bash
# 1. Log in to Azure & Azure Container Registry
az login
az acr login --name learnacrolamc

# 2. Build local Docker Image with production tag
docker build -t learnacrolamc.azurecr.io/flask-acr-app:v4.0 .

# 3. Push to private Registry
docker push learnacrolamc.azurecr.io/flask-acr-app:v4.0
```

### ACI Deployment Command
```bash
az container create \
    --resource-group acr-learning-rg \
    --name flask-acr-demo \
    --image learnacrolamc.azurecr.io/flask-acr-app:v4.0 \
    --dns-name-label flaskacrdemo2026leye \
    --ports 80 \
    --registry-username learnacrolamc \
    --registry-password "[REDACTED]" \
    --os-type Linux \
    --cpu 1 \
    --memory 1
```

---
*End of Report.*
