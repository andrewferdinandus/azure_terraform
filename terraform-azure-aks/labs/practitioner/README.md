# Practitioner Labs

Practitioner labs are for users who already understand basic AKS and Kubernetes concepts.

These labs focus on real DevOps workflows on top of the AKS platform.

For the current full lab order, see:

    ../README.md

## Track goal

Practice building, pushing, deploying, observing, and securing applications on AKS.

## Current practitioner flow

1. GitHub Actions to AKS
2. GitLab CI/CD to AKS
3. Azure DevOps to AKS
4. Jenkins to AKS
5. Key Vault and Workload Identity
6. Monitoring Basics
7. OpenTelemetry App

## Lab 01 - GitHub Actions to AKS

Folder:

    01-github-actions-to-aks

Goal:

Use GitHub Actions to build a container image, push it to a registry, and deploy it to AKS.

## Lab 02 - GitLab CI/CD to AKS

Folder:

    02-gitlab-ci-to-aks

Goal:

Use GitLab CI/CD to build, push, and deploy an application to AKS.

## Lab 03 - Azure DevOps to AKS

Folder:

    03-azure-devops-to-aks

Goal:

Use Azure DevOps Pipelines to build, push, and deploy to AKS.

## Lab 04 - Jenkins to AKS

Folder:

    04-jenkins-to-aks

Goal:

Use Jenkins to build and deploy an application to AKS.

## Lab 05 - Key Vault and Workload Identity

Folder:

    05-key-vault-workload-identity

Goal:

Use AKS Workload Identity to let an application read a secret from Azure Key Vault.

## Lab 06 - Monitoring Basics

Folder:

    06-monitoring-basics

Goal:

Use Prometheus and Grafana to observe cluster and workload metrics.

## Lab 07 - OpenTelemetry App

Folder:

    07-opentelemetry-app

Goal:

Send application telemetry to the OpenTelemetry Collector.

## Important note

These labs are practice examples.

They are not strict production templates.

After completing a lab, replace the sample app, registry, image tag, credentials method, and deployment strategy with your own workflow.
