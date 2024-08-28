ECR=837714169011.dkr.ecr.sa-east-1.amazonaws.com
VERSION="$(shell git describe --tags --long)"
APPLICATION=coe-argocd

get-version:
	@echo ${VERSION}

init:
	helm repo add argo-cd https://argoproj.github.io/argo-helm

set-version:
	$(info Changing Charts version)
	@sed -i .backup 's/^version:.*/version: '${VERSION}'/' ${APPLICATION}/Chart.yaml

test: set-version
	helm template ${APPLICATION} ${APPLICATION}/. --debug

build: test
	helm package ${APPLICATION} -d dist/

publish: build
	aws ecr get-login-password \
			--region sa-east-1 | helm registry login \
			--username AWS \
			--password-stdin ${ECR}
	helm push dist/${APPLICATION}-${VERSION}.tgz oci://${ECR}

check:
	aws ecr describe-images \
     --repository-name ${APPLICATION} \
     --region sa-east-1
