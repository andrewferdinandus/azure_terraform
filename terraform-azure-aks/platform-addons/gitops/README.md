# GitOps Platform Add-ons

This folder contains optional GitOps add-on configuration.

GitOps tools are not installed by the core Terraform platform.

They are optional because users may choose:

- Argo CD
- Flux
- No GitOps tool yet

## Current folders

- argocd
- flux

## Recommended learning approach

Start with the core AKS platform first.

Then install one GitOps tool as a lab:

1. Install Argo CD or Flux
2. Connect the Git repository
3. Deploy a sample app from Git
4. Change the manifest in Git
5. Watch the GitOps controller sync the change

## Safe access

Keep GitOps dashboards internal by default.

Use port-forward for learning access.

Do not expose Argo CD or Flux dashboards publicly without TLS, authentication, and access controls.
