# Beginner Lab 01 - Deploy Public NGINX Image

මෙම lab එකෙන් public Docker Hub image එකක් AKS cluster එකට deploy කරන basic Kubernetes flow එක ඉගෙන ගන්නවා.

මෙය beginner lab එකක්. Goal එක production-ready deployment එකක් හදන එක නෙවෙයි. Goal එක Kubernetes වල Namespace, Deployment, Service, සහ port-forward flow එක තේරුම් ගන්න එක.

## What you will learn

මෙම lab එකෙන් ඔබට මේ දේවල් ඉගෙන ගන්න පුළුවන්:

- Public container image එකක් AKS වල run කරන විදිය
- Kubernetes Namespace එකක් use කරන විදිය
- Deployment එකක් apply කරන විදිය
- Service එකක් apply කරන විදිය
- Pod, Deployment, Service verify කරන විදිය
- `kubectl port-forward` use කරලා app එක local browser එකෙන් test කරන විදිය
- Lab resources cleanup කරන විදිය

## What this lab uses

මෙම lab එක use කරන්නේ:

- AKS cluster
- `kubectl`
- Public Docker image
- Kubernetes Namespace
- Kubernetes Deployment
- Kubernetes Service
- Local port-forward

Lab manifests තියෙන්නේ:

    terraform-azure-aks/labs/beginner/01-public-nginx/manifests/

Files:

    namespace.yaml
    deployment.yaml
    service.yaml

## Prerequisites

මෙම lab එකට කලින් මේවා ready වෙලා තියෙන්න ඕන:

- AKS cluster එක create වෙලා තියෙන්න ඕන
- `kubectl` command එක install වෙලා තියෙන්න ඕන
- `kubectl` current AKS cluster එකට connect වෙලා තියෙන්න ඕන
- User node pool එක available වෙන්න ඕන

Check කරන්න:

    kubectl get nodes

Expected:

    Nodes list එකක් පේන්න ඕන.
    STATUS එක Ready වෙන්න ඕන.

## Deploy the lab

Namespace, Deployment, සහ Service apply කරන්න:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/

මෙම command එකෙන් manifests folder එක ඇතුළේ තියෙන YAML files apply වෙනවා.

Expected resources:

    namespace/beginner-nginx
    deployment.apps/nginx
    service/nginx

සමහර වෙලාවට folder apply කරන විට namespace create වෙලා ඉවර වෙන්න කලින් deployment/service apply වෙන්න try කරනවා නම් error එකක් එන්න පුළුවන්.

එහෙම වුණොත් namespace එක වෙනම apply කරලා, පස්සේ අනිත් manifests apply කරන්න:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/namespace.yaml
    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/deployment.yaml
    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/service.yaml

## Verify resources

Namespace එක verify කරන්න:

    kubectl get ns beginner-nginx

Pods බලන්න:

    kubectl get pods -n beginner-nginx

Service බලන්න:

    kubectl get svc -n beginner-nginx

All resources බලන්න:

    kubectl get all -n beginner-nginx

Expected:

    Pod STATUS එක Running වෙන්න ඕන.
    READY value එක 1/1 වගේ healthy state එකක් වෙන්න ඕන.
    nginx service එක පේන්න ඕන.

## Access the app locally

මෙම lab එක public LoadBalancer එකක් create කරන්නේ නැහැ. App එක local machine එකෙන් test කරන්න `kubectl port-forward` use කරනවා.

Run කරන්න:

    kubectl port-forward svc/nginx -n beginner-nginx 8080:80

Browser එකෙන් open කරන්න:

    http://localhost:8080

Expected page:

    Welcome to nginx!

මෙම page එක පේනවා නම් app එක AKS cluster එකේ run වෙලා Service එක හරහා access වෙලා තියෙනවා.

Port-forward stop කරන්න:

    Ctrl + C

## Troubleshooting

### Namespace not found

Error example:

    namespaces "beginner-nginx" not found

Meaning:

Namespace එක තවම create වෙලා නැහැ, නැත්නම් manifests apply කරන order එක issue එකක්.

Fix:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/namespace.yaml
    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/deployment.yaml
    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/service.yaml

### Pod not running

Pod status බලන්න:

    kubectl get pods -n beginner-nginx

More details බලන්න:

    kubectl describe pod -n beginner-nginx <pod-name>

Logs බලන්න:

    kubectl logs -n beginner-nginx <pod-name>

Possible reasons:

- Image pull issue
- Node scheduling issue
- Wrong node selector
- Resource issue

### Port already in use

Error example:

    address already in use

Meaning:

Local port `8080` already use වෙනවා.

Fix:

    kubectl port-forward svc/nginx -n beginner-nginx 8081:80

Then open:

    http://localhost:8081

## Cleanup

Lab resources delete කරන්න namespace එක delete කරන්න:

    kubectl delete namespace beginner-nginx

Verify:

    kubectl get ns beginner-nginx

Expected:

    Error from server (NotFound): namespaces "beginner-nginx" not found

මෙම error එක cleanup එකෙන් පස්සේ normal. ඒ කියන්නේ namespace එක delete වෙලා.
