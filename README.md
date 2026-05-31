# AKS DevOps Practice Platform

![Architecture Diagram](Images/azure_tf.png)

A reusable AKS Terraform platform for learning and practicing real-world DevOps workflows.

This project is designed for:

- Beginners learning AKS, Kubernetes, Terraform, and cloud DevOps
- Practitioners building CI/CD, DevSecOps, secrets, monitoring, and telemetry workflows
- Professionals practicing GitOps, release strategies, incident response, security hardening, stack-specific delivery, and final end-to-end platform projects

## Documentation

Official full documentation:

- English: [docs/en](docs/en/README.md)
- සිංහල: [docs/si](docs/si/README.md)

Aotearoa New Zealand welcome:

- te reo Māori: [docs/mi](docs/mi/README.md)

Community translation starters:

- Hindi: [docs/hi](docs/hi/README.md)
- Spanish: [docs/es](docs/es/README.md)
- Portuguese: [docs/pt](docs/pt/README.md)
- French: [docs/fr](docs/fr/README.md)
- Arabic: [docs/ar](docs/ar/README.md)
- Indonesian: [docs/id](docs/id/README.md)
- Vietnamese: [docs/vi](docs/vi/README.md)
- Japanese: [docs/ja](docs/ja/README.md)
- Korean: [docs/ko](docs/ko/README.md)
- Simplified Chinese: [docs/zh-CN](docs/zh-CN/README.md)

Translation contributions are welcome. See [docs/TRANSLATIONS.md](docs/TRANSLATIONS.md).

## Current Platform Capabilities

- Terraform-based AKS platform
- Remote Terraform backend support
- VNet, subnet, and NAT Gateway
- AKS system and user node pools
- Optional Azure Container Registry
- Docker Hub / external public registry support
- Gateway API with NGINX Gateway Fabric
- Shared platform Gateway
- Azure Key Vault
- AKS Workload Identity
- Prometheus, Grafana, Alertmanager
- OpenTelemetry Collector
- dev / qa / prod environment templates
- CI/CD examples structure
- GitOps examples structure
- Beginner, practitioner, and professional lab tracks

## Labs

Hands-on labs are organized here:

- [Labs](terraform-azure-aks/labs/README.md)

Current lab levels:

- Beginner
- Practitioner
- Professional

## Roadmap

The full learning and project roadmap is tracked here:

- [ROADMAP.md](ROADMAP.md)

Current planned path:

1. Core AKS platform
2. Beginner AKS labs
3. Practitioner CI/CD and DevSecOps labs
4. Practitioner secrets, monitoring, and telemetry labs
5. Professional GitOps and release strategy labs
6. Professional stack-specific DevSecOps and quality gates
7. Secure end-to-end final projects
8. AI-assisted DevOps labs

## Documentation quality rules

All lab guides follow these rules:

- `README.md` is the English source of truth.
- `README.si.md` follows the same headings.
- `README.si.md` follows the same command blocks.
- `README.si.md` follows the same cleanup flow.
- Lab guides must not include personal laptop paths.
- Lab guides must not assume a shared `~/projects` directory.
- Temporary app repositories should use lab-specific workspace variables.

## Learning-first approach

These labs are learning examples.

The early labs are designed to teach concepts step by step. As the learning path progresses, the labs move toward production-style patterns, DevSecOps quality gates, secure delivery, observability, and final end-to-end projects.

After completing a lab, replace the sample app, registry, image, manifests, and workflow with your own application and release process.

This platform is app-agnostic and registry-agnostic.
