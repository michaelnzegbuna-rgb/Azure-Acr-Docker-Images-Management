# Automated Docker Build & Azure Deployment Script

# 1. Configuration variables
$RegistryName = "learnacrolamc"
$LoginServer = "$RegistryName.azurecr.io"
$ImageName = "flask-acr-app"
$Tag = "v4.0"
$FullImageName = "${LoginServer}/${ImageName}:${Tag}"
$ResourceGroup = "acr-learning-rg"
$ContainerName = "flask-acr-demo"
$DnsLabel = "flaskacrdemo2026leye"
$RegistryPassword = "BN1trV9mXIp2bzzolKBaJtwL3xpkof55y14QguwxubZJ5W9YMew6JQQJ99CFAC5RqLJEqg7NAAACAZCRPfhE"

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   Azure ACR & ACI Deployment Automation" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# 2. Check for Docker
Write-Host "[*] Checking if Docker Daemon is running..." -ForegroundColor Yellow
docker version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker is not running or not installed. Please launch Docker Desktop first!"
    exit 1
}
Write-Host "[+] Docker is running." -ForegroundColor Green

# 3. Build Docker Image
Write-Host "[*] Building Docker Image: $FullImageName..." -ForegroundColor Yellow
docker build -t $FullImageName .
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed!"
    exit 1
}
Write-Host "[+] Build successful." -ForegroundColor Green

# 4. Azure Authentication & Registry Log in
Write-Host "[*] Authenticating with Azure Container Registry..." -ForegroundColor Yellow
az acr login --name $RegistryName
if ($LASTEXITCODE -ne 0) {
    Write-Host "[-] az acr login failed. Trying docker login fallback..." -ForegroundColor Yellow
    docker login $LoginServer -u $RegistryName -p $RegistryPassword
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Authentication failed!"
        exit 1
    }
}
Write-Host "[+] Authenticated successfully." -ForegroundColor Green

# 5. Push image to registry
Write-Host "[*] Pushing image to Azure Container Registry..." -ForegroundColor Yellow
docker push $FullImageName
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker push failed!"
    exit 1
}
Write-Host "[+] Image pushed successfully." -ForegroundColor Green

# 6. Deploy to Azure Container Instances (ACI)
Write-Host "[*] Redeploying Container Instance: $ContainerName..." -ForegroundColor Yellow
az container create `
    --resource-group $ResourceGroup `
    --name $ContainerName `
    --image $FullImageName `
    --dns-name-label $DnsLabel `
    --ports 80 `
    --registry-username $RegistryName `
    --registry-password $RegistryPassword `
    --os-type Linux `
    --cpu 1 `
    --memory 1

if ($LASTEXITCODE -ne 0) {
    Write-Error "Deployment to ACI failed!"
    exit 1
}

Write-Host "==============================================" -ForegroundColor Green
Write-Host "   Deployment Completed Successfully!" -ForegroundColor Green
Write-Host "   Live URL: http://$DnsLabel.westeurope.azurecontainer.io" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
