# Common errors

## Apply process

`ERROR`

- sa-east-1a|b|c failed to fetch resource from kubernetes: the server could not find the requested resource

`SOLUTION`

- Run make apply again

`ERROR`

- Error: An error occurred (AccessDenied) when calling the AssumeRole operation: User: arn:aws:sts::383676904909:assumed-role/BUAdministratorAccessRole/C80407A@br.experian.local is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::383676904909:role/BURoleForSRE
  Unable to connect to the server: getting credentials: exec: executable aws failed with exit code 254

`SOLUTION`

- Run 'aws eks --region sa-east-1 update-kubeconfig --name mlops-dragon-03-dev' again

---

`ERROR`

- Error: create: failed to create: Post "https://...gr7.sa-east-1.eks.amazonaws.com/api/v1/namespaces/deploy-system/secrets": http2: client connection lost
- Error: could not get information about the resource: Get "https://XXX.gr7.sa-east-1.eks.amazonaws.com/apis/rbac.authorization.k8s.io/v1/clusterroles/secretproviderclasses-admin-role": dial tcp: lookup XXXX.gr7.sa-east-1.eks.amazonaws.com: i/o timeout

`SOLUTION`

- Run make apply again, this can be a intermittent internet issue

---

`ERROR`

- Error: Failed to save state
- Error saving state: failed to upload state: ExpiredToken: The security token included in the request is expired status code: 403, request id: XXXX..

`SOLUTION`

- Login again in the AWS account

---

`GET LOGS`

- kubectl describe pod -n deploy-system argocd-server-64f54f489d-hsqqd
- kubectl logs -n kube-system secrets-provider-aws-secrets-store-csi-driver-provider-aws6dxwr

`ERROR`

- "Warning FailedMount 8s (x5 over 18s) kubelet MountVolume.SetUp failed for volume "argocd-repositories" : rpc error: code = Unknown desc = failed to mount secrets store objects for pod deploy-system/argocd-server-64f54f489d-hsqqd, err: rpc error: code = Unknown desc = Failed to fetch secret from all regions: coe-data-platform/coe-data-platform-01/argocd_prod-repositorie
- Failure getting secret values from provider type secretsmanager: Failed to fetch secret from all regions: coe-data-platform/coe-data-platform-01/argocd_prod-repositories

`SOLUTION`

- This problem occur when the OpenID Connect provider URL fingerprint is not setup at IAM -> OIDC Cluster -> Thumbprints
- Run these command inside a pod like Istio (https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html)

---

`ERROR`

- Error: Kubernetes cluster unreachable: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable

`SOLUTION`

```bash
$ aws eks --region sa-east-1 update-kubeconfig --name mlops-eks-cl1-dev
$ export KUBE_CONFIG_PATH="~/.kube/config"

```

---

`ERROR`

- Error: Kubernetes cluster unreachable: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"

`SOLUTION`

- Downgrade terraform helm version to 2.5.1

---

## Destroy process

- Error: uninstallation completed with 1 error(s): timed out waiting for the condition
- Warning: Helm uninstall returned an information message - These resources were kept due to the resource policy
- Error: deleting Security Group

`SOLUTION`

- Execute make destroy again
