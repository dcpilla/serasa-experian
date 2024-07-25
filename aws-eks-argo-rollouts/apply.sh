#!/bin/bash

aws_region=@@AWS_REGION@@
aws_account_id=@@AWS_ACCOUNT_ID@@
eks_domain_name=@@EKS_DOMAIN_NAME@@
eks_cluster_name=@@EKS_CLUSTER_NAME@@
eks_namespace=@@EKS_NAMESPACE@@

echo
echo "Assuming role BURoleForDevSecOpsCockpitService..."

ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsCockpitService --role-session-name DevSecOpsCockpitService --region $aws_region)
if [ $? -ne 0 ];then
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')

echo
echo "Generating configuration artifacts..."

routeFile="argo-rollouts-route.yaml"

echo
echo "Authenticating Kubeconfig in Amazon EKS..."

aws eks update-kubeconfig --name $eks_cluster_name --kubeconfig $eks_cluster_name.conf --region $aws_region
if [ $? -ne 0 ];then
  exit 1
fi


echo
echo "Adding Helm Repositories..."

helm repo add argo https://argoproj.github.io/argo-helm --kubeconfig $eks_cluster_name.conf
helm repo update argo --kubeconfig $eks_cluster_name.conf

echo
echo "Preparing Cluster..."

kubectl get ns $eks_namespace --kubeconfig $eks_cluster_name.conf || (kubectl create ns $eks_namespace --kubeconfig $eks_cluster_name.conf && kubectl label ns $eks_namespace istio-injection=enabled --overwrite --kubeconfig $eks_cluster_name.conf)        


echo
echo "Installing argo-rollouts..."

helm upgrade -i argo-rollouts argo/argo-rollouts \
--namespace $eks_namespace \
--values chart/values.yaml \
--kubeconfig $eks_cluster_name.conf

echo
echo "Creating Argo-Rollouts Route..."

cat << EOF > $routeFile
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: argo-rollouts-dashboard-gateway
  namespace: ${eks_namespace}
spec:
  selector:
    istio: ingress
  servers:
    - hosts:
        - argo-rollouts.${eks_domain_name}
      port:
        name: http
        number: 80
        protocol: HTTP
      tls:
        httpsRedirect: true
    - hosts:
        - argo-rollouts.${eks_domain_name}
      port:
        name: https
        number: 8080
        protocol: HTTP

---

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: argo-rollouts-dashboard-virtual-service
  namespace: ${eks_namespace}
spec:
  gateways:
    - argo-rollouts-dashboard-gateway
  hosts:
    - argo-rollouts.${eks_domain_name}
  http:
    - route:
        - destination:
            host: argo-rollouts-dashboard
            port:
              number: 8080
          headers:
            request:
              set:
                X-Forwarded-Proto: https
EOF

kubectl apply -f $routeFile --kubeconfig $eks_cluster_name.conf

echo
echo "Argo URL: https://argo-rollouts.${eks_domain_name}"

rm -f $routeFile
rm -f ${eks_cluster_name}.conf

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
