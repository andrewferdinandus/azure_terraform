# Practitioner Lab 01 - GitHub Actions to AKS

මෙම lab එකෙන් GitHub Actions workflow එකක් use කරලා container image එකක් build කරලා registry එකට push කරලා AKS cluster එකට deploy කරන flow එක ඉගෙන ගන්නවා.

මෙය practitioner-level lab එකක්. Beginner labs වල Kubernetes basics practice කළාට පස්සේ CI/CD pipeline එකක් හරහා deployment automate කරන විදිය මෙතනින් ඉගෙන ගන්නවා.

## What you will learn

මෙම lab එකෙන් ඔබට මේ දේවල් ඉගෙන ගන්න පුළුවන්:

- GitHub Actions workflow structure එක
- Pipeline jobs separate කරන විදිය
- Docker image build කරන විදිය
- Container registry එකට image push කරන විදිය
- AKS cluster එකට deploy කරන විදිය
- Kubernetes rollout verify කරන විදිය
- Pipeline variables/secrets use කරන basic pattern එක

## Learning-first example

මෙම lab එක learning-first example එකක්.

Goal එක production-ready enterprise pipeline එකක් හදන එක නෙවෙයි. Goal එක GitHub Actions CI/CD flow එක තේරුම් ගන්න එක.

මෙම lab එකෙන් පස්සේ ඔබට ඔබගේ real application, registry, environments, approvals, සහ security rules අනුව pipeline එක improve කරන්න පුළුවන්.

## Authentication note

මෙම lab එක Azure login සහ registry login සඳහා service principal credentials use කරනවා.

Learning labs වලට මෙය simpleයි. Production වලදී GitHub OIDC / federated identity වගේ secretless authentication pattern එකක් prefer කරන්න.

Secrets code එකට commit කරන්න එපා. GitHub repository secrets වලට විතරක් දාන්න.

## Supported registry paths

මෙම lab එක registry paths කිහිපයක් support කරන pattern එකක් ලෙස හිතන්න පුළුවන්:

- Azure Container Registry
- Docker Hub
- Other private container registries

Azure AKS learning path එකට recommended path එක:

    Azure Container Registry

Docker Hub example එකක් නම් registry server එක මෙහෙම වෙන්න පුළුවන්:

    docker.io

## Folder structure

Lab files structure එක:

    app/
      sample app files

    k8s/
      Kubernetes manifests

    github-actions/
      GitHub Actions workflow template

Workflow template එක `.github/workflows/` path එකට copy කරන්න.

## Copy workflow into GitHub Actions path

GitHub Actions workflow file එක repo root එකේ `.github/workflows/` folder එකට copy කරන්න.

Expected final path:

    .github/workflows/build-deploy-aks.yaml

Pipeline trigger වෙන්නේ workflow file එක GitHub repo එකේ තිබ්බම.

ඔබ workflow file එක update කරලා push කළාම GitHub Actions run එකක් start වෙන්න පුළුවන්.

## Pipeline jobs

මෙම workflow එක jobs කිහිපයකට split කරලා තියෙනවා:

    validate
      |
      v
    build_push
      |
      v
    deploy
      |
      v
    verify

මෙම structure එකෙන් pipeline එක read කරන්න ලේසි වෙනවා.

- `validate` job එක required files තියෙනවද බලනවා
- `build_push` job එක Docker image build කරලා registry එකට push කරනවා
- `deploy` job එක AKS cluster එකට manifests apply කරනවා
- `verify` job එක deployment rollout සහ pods/services check කරනවා

## Prepare Azure CI/CD variables

මෙම lab එක AKS වලට deploy කරනවා සහ image එක registry එකට push කරනවා.

Workflow run කරන්න කලින් required Azure සහ registry values shared guide එකෙන් සකස් කරන්න:

    ../../shared/azure-login-and-cicd-variables.md

Sinhala guide:

    ../../shared/azure-login-and-cicd-variables.si.md

මෙම shared guide එකෙන් `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `REGISTRY_LOGIN_SERVER`, `REGISTRY_USERNAME`, `REGISTRY_PASSWORD` වගේ values ගන්නේ කොහොමද කියලා explain කරනවා.

## Required GitHub secrets

GitHub repository secrets වලට මේ values add කරන්න:

    AZURE_CLIENT_ID
    AZURE_CLIENT_SECRET
    AZURE_TENANT_ID
    AZURE_SUBSCRIPTION_ID
    AZURE_RESOURCE_GROUP
    AKS_CLUSTER_NAME
    REGISTRY_LOGIN_SERVER
    REGISTRY_USERNAME
    REGISTRY_PASSWORD

Secrets add කරන path එක:

    GitHub repository
    -> Settings
    -> Secrets and variables
    -> Actions
    -> New repository secret

Secret values expose කරන්න එපා.

## Image tag

මෙම workflow එක image tag එකට Git commit SHA එක use කරනවා.

ඒකෙන් එක් එක් pipeline run එකට unique image tag එකක් ලැබෙනවා.

Example:

    <registry-login-server>/<image-name>:<git-sha>

මෙම pattern එක rollback/debugging වලට useful.

## Deployment method

Deployment stage එක `IMAGE_PLACEHOLDER` replace කරලා actual image value එක Kubernetes Deployment manifest එකට inject කරනවා.

Conceptual command flow එක:

    sed "s|IMAGE_PLACEHOLDER|$IMAGE|g" k8s/deployment.yaml \
      | kubectl apply -f -

ඊට පස්සේ namespace සහ service apply කරනවා.

## Local manifest test

Pipeline එකට කලින් manifests locally test කරන්න පුළුවන්.

Namespace apply කරන්න:

    kubectl apply -f terraform-azure-aks/labs/practitioner/01-github-actions-to-aks/k8s/namespace.yaml

Deployment manifest එක image value එකක් substitute කරලා apply කරන්න:

    sed "s|IMAGE_PLACEHOLDER|<your-image>|g" terraform-azure-aks/labs/practitioner/01-github-actions-to-aks/k8s/deployment.yaml \
      | kubectl apply -f -

Service apply කරන්න:

    kubectl apply -f terraform-azure-aks/labs/practitioner/01-github-actions-to-aks/k8s/service.yaml

Pods සහ rollout verify කරන්න:

    kubectl get pods -n practitioner-github-actions
    kubectl rollout status deployment/github-actions-demo -n practitioner-github-actions

Service local machine එකට port-forward කරන්න:

    kubectl port-forward svc/github-actions-demo -n practitioner-github-actions 8084:80

Browser එකෙන් open කරන්න:

    http://localhost:8084

Expected:

    Sample app page එක load වෙන්න ඕන.

## Cleanup

Lab resources cleanup කරන්න:

    kubectl delete namespace practitioner-github-actions

මෙයින් namespace එක තුළ තිබුණු Deployment, Service, Pod resources delete වෙනවා.

## Important note

මෙම lab එක learning-purpose CI/CD example එකක්.

Production pipeline එකකදී consider කරන්න:

- GitHub OIDC / federated credentials
- Least privilege permissions
- Protected branches
- Environment approvals
- Image scanning
- SBOM
- Signed images
- GitOps promotion
