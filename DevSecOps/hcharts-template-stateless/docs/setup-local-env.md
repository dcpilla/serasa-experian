# How-to set up a local enviroment

1. Configure the Docker Engine to push the images to the local registry

    1. Create the file `/etc/docker/daemon.json` with the following content:

        ```json
        {
        "insecure-registries" : ["localhost:5000"]
        }
        ```

    2. Restart the docker service:

        ```bash
        sudo systemctl restart docker
        ```

2. Install a Minikube: <https://minikube.sigs.k8s.io/docs/start/>

3. Minikube needs the Serasa's proxy cert

    After the first start of the minikube, it will create a folder ~/.minikube.

    You will need to copy the proxy cert so the Minikube can download images from public repositories and recreate the minikube cluster.

    ```bash
    cp /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem ~/.minikube/certs/
    minikube stop
    minikube delete
    minikube start
    ```

    ref.: https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/

4. Start the Minikube cluster with the following command:

    ```bash
    minikube start --memory=10000 --cpus=2 --insecure-registry "10.0.0.0/24"
    ```

5. Add the registry addon

    ```bash
    minikube addons enable registry
    ```

6. Export the registry port, so you can push images from your local machine:

    ```bash
    kubectl port-forward --namespace kube-system service/registry 5000:80 > registry.log 2>&1 &
    ```

    On your local machine you should now be able to reach the minikube registry by using `curl http://localhost:5000/v2/_catalog`

7. Install Istio into the Minikube: <https://istio.io/latest/docs/setup/getting-started/>
    - I used the `istioctl` strategy
    - After download and install the binary `instioctl`, I've just to run the following command:

    ```bash
    instioctl install
    ```

8. Install the Helm command: <https://helm.sh/docs/intro/install/>

9. Open a new terminal and execute the command below to open the k8s dashboard (it will export the service and open the dashboard on your default browser):

    ```bash
    minikube dashboard
    ```

## To check the Istio usage

We will use Instio as a ingress controller, at first. The ideia is involve the solution to be able to choose from ingress controller to mesh usage.

Install the addons that came with the Istio installation (you can check the details on the [View the dashboard](https://istio.io/latest/docs/setup/getting-started/#dashboard) page.

Go to the directory where you donwloaded the Istio code and run the command:

```bash
kubectl apply -f samples/addons
```

Whait the deployment of the addons and run the following command in a new terminal:

```bash
istioctl dashboard kiali
```

It will export the service and open the Kiali dashboard in your default browser.

### Accessing the app through Istio Ingress

Run this command in a new terminal window to start a Minikube tunnel, that sends traffic to your Istio Ingress Gateway (Service of type `LoadBalancer`):

```bash
  minikube tunnel
```

If you face issues using `minikube tunnel`, an alternative is to change the Service Type to `NodePort`:

```bash
kubectl patch svc istio-ingressgateway --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]' -n istio-system
```
