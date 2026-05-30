# Argo CD Add-on

Argo CD can be installed as an optional GitOps lab.

This project keeps Argo CD outside the core Terraform platform so users can choose whether they want GitOps installed.

Recommended safe learning access:

- Keep Argo CD service as ClusterIP
- Use kubectl port-forward for local access
- Do not expose Argo CD publicly without TLS, authentication, and access controls

Install example:

    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update

    helm install argocd argo/argo-cd \
      --namespace argocd \
      --create-namespace \
      -f platform-addons/gitops/argocd/values.yaml \
      --wait

Verify:

    kubectl get pods -n argocd
    kubectl get svc -n argocd

Access locally:

    kubectl port-forward svc/argocd-server -n argocd 8080:443
