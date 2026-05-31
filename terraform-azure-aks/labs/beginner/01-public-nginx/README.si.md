# Beginner Lab 01 - Public NGINX Image Deploy කිරීම

මෙම lab එකෙන් අපි public Docker Hub image එකක් AKS cluster එකට deploy කරන විදිය ඉගෙන ගන්නවා.

මෙය beginner-friendly lab එකක්. Goal එක production setup එකක් හදන එක නෙවෙයි. Goal එක Kubernetes වල basic deployment flow එක තේරුම් ගන්න එක.

## මේ lab එකෙන් ඉගෙන ගන්න දේ

මෙම lab එකෙන් ඔබට පහත දේවල් ඉගෙන ගන්න පුළුවන්:

- Kubernetes Namespace එකක් create කරන විදිය
- Deployment එකක් create කරන විදිය
- Public Docker image එකක් run කරන විදිය
- Service එකක් create කරන විදිය
- Pod, Deployment, Service verify කරන විදිය
- Port-forward use කරලා app එක browser එකෙන් access කරන විදිය
- Lab resources cleanup කරන විදිය

## මේ lab එක කරන්නේ ඇයි?

Kubernetes වල application එකක් run කරන්න සාමාන්‍යයෙන් මේ flow එක තියෙනවා:

    Namespace
      |
      v
    Deployment
      |
      v
    Pod
      |
      v
    Service
      |
      v
    Access / Test

මෙම lab එකෙන් ඒ basic flow එක practical විදියට practice කරනවා.

## කලින් තිබිය යුතු දේ

මෙම lab එකට පෙර මේවා ready වෙලා තියෙන්න ඕන:

- AKS cluster එක create වෙලා තියෙන්න ඕන
- kubectl command එක වැඩ කරන්න ඕන
- kubeconfig එක current AKS cluster එකට connect වෙලා තියෙන්න ඕන
- user node pool එක available වෙන්න ඕන

Check කරන්න:

    kubectl get nodes

Expected:

    Nodes list එකක් පේන්න ඕන.
    STATUS එක Ready වෙන්න ඕන.

## Lab files

මෙම lab එකේ manifests තියෙන්නේ:

    terraform-azure-aks/labs/beginner/01-public-nginx/manifests/

Files:

    namespace.yaml
    deployment.yaml
    service.yaml

## Step 1 - Namespace එක create කිරීම

Namespace එකෙන් අපි lab resources වෙනම group එකකට දානවා.

Command:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/namespace.yaml

Verify:

    kubectl get ns beginner-nginx

Expected:

    beginner-nginx namespace එක Active ලෙස පේන්න ඕන.

## Step 2 - Deployment එක create කිරීම

Deployment එකෙන් nginx pod එක run කරනවා.

Command:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/deployment.yaml

Verify:

    kubectl get pods -n beginner-nginx

Expected:

    nginx pod එක Running වෙන්න ඕන.

Example:

    NAME                     READY   STATUS    RESTARTS   AGE
    nginx-xxxxxxxxxx-xxxxx   1/1     Running   0          30s

## Step 3 - Service එක create කිරීම

Service එකෙන් pod එකට stable internal access point එකක් ලැබෙනවා.

Command:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/service.yaml

Verify:

    kubectl get svc -n beginner-nginx

Expected:

    nginx service එක පේන්න ඕන.

## Step 4 - App එක local machine එකෙන් access කිරීම

මෙම lab එකේ public LoadBalancer එකක් create කරන්නේ නැහැ.

අපි port-forward use කරනවා.

Command:

    kubectl port-forward svc/nginx -n beginner-nginx 8080:80

ඊට පස්සේ browser එකෙන් open කරන්න:

    http://localhost:8080

Expected page:

    Welcome to nginx!

මෙම page එක පේනවා නම් deployment එක successful.

## Step 5 - Resources verify කිරීම

Command:

    kubectl get all -n beginner-nginx

Expected:

    pod
    service
    deployment
    replicaset

මේ resources පේන්න ඕන.

## Common errors

### namespace not found

Error:

    namespaces "beginner-nginx" not found

Meaning:

Namespace එක create වෙලා නැහැ, නැත්නම් resources apply කරන order එක වැරදි.

Fix:

    kubectl apply -f terraform-azure-aks/labs/beginner/01-public-nginx/manifests/namespace.yaml

ඊට පස්සේ deployment/service apply කරන්න.

### pod Pending

Check:

    kubectl describe pod -n beginner-nginx <pod-name>

Possible reasons:

- Node selector match වෙන්නේ නැහැ
- Resource issue
- Image pull issue

### port-forward already in use

Error:

    address already in use

Meaning:

Local port 8080 already use වෙනවා.

Fix:

    kubectl port-forward svc/nginx -n beginner-nginx 8081:80

Then open:

    http://localhost:8081

## Cleanup

Lab එක ඉවර වුණාම namespace එක delete කරන්න:

    kubectl delete namespace beginner-nginx

Verify:

    kubectl get ns beginner-nginx

Expected:

    Error from server (NotFound)

ඒක normal. ඒ කියන්නේ namespace එක delete වෙලා.

## මතක තියාගන්න

මෙම lab එකෙන් අපි ඉගෙන ගත්තේ Kubernetes basic app deployment flow එක.

Main idea එක:

    Deployment creates Pods.
    Service gives stable access to Pods.
    port-forward lets you test the Service locally.

මෙය production exposure method එකක් නෙවෙයි. Production වල Gateway API, Ingress, LoadBalancer, security rules වගේ දේවල් හරියට configure කරන්න ඕන.
