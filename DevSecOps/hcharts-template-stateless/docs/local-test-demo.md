# How to run a local test

## Prepare you environment

If you forgot to prepare your local environment, now it's the time. Follow the instructions in [How to setting up your local environment](docs/setup-local-env.md)

## Quick test

You can execute the following command to run the complete CI/CD pipeline:

```bash
bash cicd-pipeline.sh demo-app 0.1.0 hchart-stateless 0.1.0 stg
```

The parameters used on the command are: `<APP_NAME> <APP_VERSION> <HCHART_TEMPLATE> <HCHART_TEMPLATE_VERSION> <ENVIRONMENT>`

| Parameters              | Type       | Description       |
|-------------------------|------------|------------|
| APP_NAME                |  String    |  Application name. It is used to get the code, create the charts, namespace, etc. |
| APP_VERSION             |  String (semver version)    | Version of the application. It is used to set the charts version too. |
| HCHART_TEMPLATE         | String | Helm Charts Template' name to use. |
| HCHART_TEMPLATE_VERSION | String (semver version) | Version of the helm charts template. Identify the `tag` from wich the automation will download the code |
| ENVIRONMENT             | String ('stg', 'qa', 'uat', 'prod') | Identify the environment

### Helpful Commands

Some commands that you may need during tests:

- `helm list` : list the charts installled
- `helm uninstall demo-app` : uninstall the release demo-app
- `kubectl config set-context --current --namespace=demo` : set the `demo` namespace as the default one

## Locally CI-CD

Lets say we want to deploy the version 1.0.0 of the `demo-app` application using the template tagged with `0.1.0`, in the environment `stg`.

During the CI, a Docker image will be tagged with the version informed in the file `.jenkins.yml`. The CD stage will use the same tag to deploy the application.

### Configure the deployment

1. Edit the file `.jenkins.yml` and change the `version` to 1.0.0

2. Run the command:

    ```bash
    bash cicd-pipeline.sh demo-app 1.0.0 hchart-stateless 0.1.0 stg
    ```

### Checking the application

You can get the URL to access the application through Istio Gateway by running these commands:

```bash
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(minikube ip)
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "http://$GATEWAY_URL/"
```

The last line will show the URL you can use to call the endpoint of the `demo-app`.

Look at the [app documentation](/demo-app/README.md) to see the endpoints.
