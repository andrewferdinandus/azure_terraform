# CI/CD Examples

This folder contains CI/CD pipeline examples for deploying applications to AKS.

## Supported CI/CD tools

Planned examples:

- GitHub Actions
- GitLab CI/CD
- Azure DevOps
- Jenkins

## Common pipeline flow

Most examples follow this pattern:

    Source code
        |
        v
    Build container image
        |
        v
    Push image to registry
        |
        v
    Deploy to AKS
        |
        v
    Verify rollout

## Registry options

The examples can be adapted for:

- Azure Container Registry
- Docker Hub
- GitHub Container Registry
- GitLab Container Registry
- Quay
- Private registries with imagePullSecret

## Learning purpose

These examples are not strict production templates.

They are starter labs for learning how CI/CD works with AKS.

After completing an example, replace the sample app, registry, image tag, manifests, and deployment method with your own workflow.
