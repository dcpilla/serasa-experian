# CoE ArgoCD Odin Apps

Repo to keep The ArgoCD configuration for the applications of the Odin project

A main Application for each environment our AWS account will orchestrate the set up of the applications in these environments.

This solution was planned in an architecture where each environment has one EKS with an ArgoCD in place.

## Develop Environment

Create the namespace `argocd-apps`

Apply the configuration for the develop environment:

```bash
kubectl apply --filename apps-develop.yaml
```