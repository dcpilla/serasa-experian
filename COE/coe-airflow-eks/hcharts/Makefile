ECR=837714169011.dkr.ecr.sa-east-1.amazonaws.com
VERSION=`cat .version`
AIRFLOW_IMAGE=837714169011.dkr.ecr.sa-east-1.amazonaws.com/airflow:v2.7.3-p3.11-bookworm-j6yDP0pyTui7_gypNYPyyw-temp

init:
	helm repo add apache-airflow https://airflow.apache.org

test:
	helm dependency build helm-mlops-airflow
	helm template helm-mlops-airflow helm-mlops-airflow/. --debug

set_airflow_version:
	hacks/set_airflow_image.sh ${AIRFLOW_IMAGE}

build: test
	helm package helm-mlops-airflow -d dist/

publish: build
	aws ecr get-login-password \
			--region sa-east-1 | helm registry login \
			--username AWS \
			--password-stdin ${ECR}
	helm push dist/helm-mlops-airflow-${VERSION}.tgz oci://${ECR}

check:
	aws ecr describe-images \
     --repository-name helm-mlops-airflow \
     --region sa-east-1
