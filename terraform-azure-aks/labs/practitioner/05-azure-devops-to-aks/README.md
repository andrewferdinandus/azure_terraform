# Practitioner Lab 05 - Azure DevOps to AKS

This lab shows how to use Azure DevOps Pipelines to build a backend application image, push it to Azure Container Registry, and deploy it to AKS.

This lab uses the 3-tier Node.js sample app as a more realistic application example.

Sample app repository:

    https://github.com/andrewferdinandus/3-tier-nodeapp

## What you will learn

- Azure DevOps pipeline stages
- Building a Node.js backend Docker image
- Pushing an image to ACR
- Deploying MySQL to AKS
- Deploying a backend API to AKS
- Using Kubernetes Secrets, ConfigMaps, PVCs, Deployments, and Services
- Verifying rollout from Azure DevOps
- Testing backend health from your local machine

## Lab scope

This lab deploys:

- MySQL
- Node.js backend API

It does not deploy the frontend yet.

A future lab can extend this into a full 3-tier AKS deployment.

## App source

The app source lives in a separate repository:

    3-tier-nodeapp

This platform repository stores the lab template and reference files only.

## Required Azure DevOps setup

Create or use an Azure DevOps project.

Recommended project name:

    aks-azure-devops-cicd-lab

You can use either:

- Azure Repos Git
- GitHub connected to Azure Pipelines

If you use Azure Repos as a copy of a GitHub repo, make sure the Azure Repos copy is updated when GitHub changes.

## Required pipeline variables

Add these variables in Azure DevOps:

    Pipelines -> select pipeline -> Edit -> Variables

Variables:

    AZURE_CLIENT_ID
    AZURE_CLIENT_SECRET
    AZURE_TENANT_ID
    AZURE_SUBSCRIPTION_ID
    AZURE_RESOURCE_GROUP
    AKS_CLUSTER_NAME
    REGISTRY_LOGIN_SERVER
    REGISTRY_USERNAME
    REGISTRY_PASSWORD

For this platform example:

    AZURE_RESOURCE_GROUP = rg-aks-dev-001
    AKS_CLUSTER_NAME = aks-dev-001
    REGISTRY_LOGIN_SERVER = acraksdev001andrew.azurecr.io

For ACR using the same service principal:

    REGISTRY_USERNAME = AZURE_CLIENT_ID
    REGISTRY_PASSWORD = AZURE_CLIENT_SECRET

Mark these as secret:

    AZURE_CLIENT_SECRET
    REGISTRY_PASSWORD

## Required permissions

The service principal should have:

- Permission to get AKS credentials
- AcrPush permission on ACR

For learning, Contributor on the resource group or subscription can be used.

For production, use least privilege.

## Files in this lab

    backend/Dockerfile
      Dockerfile used to build the backend image

    k8s/
      Kubernetes manifests for MySQL and backend

    azure-pipelines/azure-pipelines.yml
      Azure DevOps pipeline template

## Files to copy into the app repository

Copy these into the root of the 3-tier app repository:

    backend/Dockerfile
    k8s/
    azure-pipelines.yml

The app repository should have:

    backend/
      Dockerfile
      package.json
      package-lock.json
      server.js

    k8s/
      namespace.yaml
      mysql-secret.yaml
      mysql-init-configmap.yaml
      mysql-pvc.yaml
      mysql-deployment.yaml
      mysql-service.yaml
      backend-deployment.yaml
      backend-service.yaml

    azure-pipelines.yml

## Pipeline stages

The pipeline uses these stages:

    Validate
      |
      v
    BuildPush
      |
      v
    Deploy
      |
      v
    Verify

## How it works

The pipeline:

1. Validates required files
2. Builds the backend Docker image
3. Pushes the image to ACR
4. Logs in to Azure
5. Gets AKS credentials
6. Installs kubectl
7. Deploys MySQL resources
8. Deploys backend resources
9. Verifies rollouts

## Local validation

Before running the pipeline, you can test the backend Docker build locally from the app repository:

    docker build -t node-backend-test backend

Run the container locally:

    docker run --rm -p 5002:5000 \
      -e DB_HOST=host.docker.internal \
      -e DB_USER=root \
      -e DB_PASSWORD=password \
      -e DB_NAME=devops_db \
      node-backend-test

Test health:

    curl http://localhost:5002/health

If a local database is available, expected output:

    {"status":"UP","database":"CONNECTED"}

## Verify after pipeline success

From your local machine:

    kubectl get pods -n practitioner-azure-devops
    kubectl get svc -n practitioner-azure-devops
    kubectl rollout status deployment/mysql -n practitioner-azure-devops
    kubectl rollout status deployment/node-backend -n practitioner-azure-devops

Port-forward backend service:

    kubectl port-forward svc/node-backend -n practitioner-azure-devops 8086:80

Test health:

    curl http://localhost:8086/health

Expected:

    {"status":"UP","database":"CONNECTED"}

## Common issues

### Docker build uses old Dockerfile

If Azure DevOps still runs:

    npm ci --omit=dev

but your GitHub repo has:

    npm install --omit=dev

then Azure DevOps may be building an outdated Azure Repos copy.

Fix:

- Push the latest code to Azure Repos
- Or connect the pipeline directly to GitHub

### kubectl command not found

The Azure CLI image may not include kubectl.

This pipeline uses:

    az aks install-cli

before running kubectl commands.

### Backend readiness probe fails

The backend health endpoint checks MySQL connectivity.

If MySQL is not ready yet, the backend may not become ready immediately.

Check:

    kubectl get pods -n practitioner-azure-devops
    kubectl logs deployment/mysql -n practitioner-azure-devops
    kubectl logs deployment/node-backend -n practitioner-azure-devops

## Cleanup

Delete the namespace:

    kubectl delete namespace practitioner-azure-devops

Optional ACR cleanup:

    az acr repository delete \
      --name <acr-name> \
      --repository node-backend \
      --yes

## Security cleanup

After testing, remove or rotate temporary service principal secrets used in Azure DevOps.

Do not commit secrets into Git.

## Important note

This is a learning lab.

Production pipelines should use:

- Service connections
- OIDC or federated credentials where possible
- Least privilege permissions
- Environment approvals
- Secret rotation
- DevSecOps scanning
- GitOps or controlled deployment promotion
