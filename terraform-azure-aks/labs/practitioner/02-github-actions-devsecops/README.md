# Practitioner Lab 02 - GitHub Actions DevSecOps Checks

This lab adds DevSecOps checks to the GitHub Actions learning flow.

It does not require:

- Azure credentials
- Registry credentials
- Paid security scanning accounts
- AKS access
- GitHub Advanced Security

It does not replace Lab 01.

Lab 01 teaches:

    build -> push -> deploy -> verify

This lab teaches:

    validate -> scan files -> scan config -> build image -> scan image

## What you will learn

- How to add security checks before deployment
- How to scan repository files
- How to scan Dockerfile and Kubernetes YAML
- How to build a local Docker image in CI
- How to scan a local container image
- How to fail a pipeline when critical image vulnerabilities are found
- Why DevSecOps belongs in CI/CD
- Why action pinning matters

## Tool used

This lab uses Trivy for learning security scans.

Trivy can scan:

- Container images
- Filesystems
- Git repositories
- Kubernetes configuration
- Infrastructure configuration

## Important supply-chain note

Security tools are also dependencies.

Pin action versions carefully and review upstream project security advisories.

For stronger production-style security, pin actions to trusted commit SHAs and rotate secrets if you suspect a compromised CI/CD dependency.

## Folder structure

    github-actions/
      DevSecOps workflow template

    notes/
      Reserved for additional DevSecOps notes

## Workflow file

The workflow template is stored here:

    labs/practitioner/02-github-actions-devsecops/github-actions/devsecops-checks.yaml

Copy it to:

    .github/workflows/devsecops-checks.yaml

## Workflow jobs

This workflow uses separate jobs:

    validate
      |
      v
    scan_filesystem
      |
      v
    scan_config
      |
      v
    build_image
      |
      v
    scan_image
      |
      v
    summary

## Why this lab does not deploy

This lab focuses on security checks.

Deployment is already covered in Lab 01.

A later advanced lab can combine DevSecOps checks with deployment approvals, OIDC federation, and environment protection rules.

## Expected result

The workflow should:

- Validate required files
- Scan repository files
- Scan Dockerfile and Kubernetes YAML
- Build a local Docker image
- Scan the image
- Fail if critical or high image vulnerabilities are found

## What to do if the image scan fails

Read the vulnerability output.

Possible actions:

- Use a newer base image
- Use a smaller base image
- Patch dependencies
- Rebuild the image
- Accept risk only through a documented exception process

## Cleanup

This workflow does not deploy to AKS.

No Kubernetes cleanup is required.

## Important note

This is a learning lab.

Production DevSecOps pipelines should also consider:

- OIDC instead of long-lived credentials
- Least privilege permissions
- Branch protection
- Environment approvals
- Dependency review
- Secret scanning
- SBOM generation
- Signed images
- Policy as code
