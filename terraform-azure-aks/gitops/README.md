# GitOps

This folder is reserved for GitOps examples and environment promotion workflows.

GitOps means the Git repository becomes the source of truth for Kubernetes workloads and platform add-ons.

Supported GitOps tools planned for this project:

- Argo CD
- Flux

## Structure

- `argocd/` — Argo CD bootstrap and app-of-apps examples
- `flux/` — Flux bootstrap and Kustomization examples
- `apps/` — application desired state for dev, qa, and prod
- `platform-addons/` — GitOps-managed platform add-ons such as Gateway API, monitoring, and secrets integrations

## Environments

- `apps/dev/` — development workloads
- `apps/qa/` — QA/staging workloads
- `apps/prod/` — production-style workloads

Detailed English and Sinhala GitOps guides will be added during the documentation phase.
