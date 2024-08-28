## SRE Dev
AWS_ACCOUNT_ID=837714169011
REPO=airflow-mount-secrets
VERSION=`cat .version`

build:
	echo "Building image, version ${VERSION}"
	docker build  --progress plain -t ${REPO}:v${VERSION} .

publish: build
	echo "Building and publishing the docker image ${REPO}:v${VERSION}"
	aws ecr get-login-password --region sa-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.sa-east-1.amazonaws.com
	docker tag ${REPO}:v${VERSION} ${AWS_ACCOUNT_ID}.dkr.ecr.sa-east-1.amazonaws.com/${REPO}:v${VERSION}
	docker tag ${REPO}:v${VERSION} ${AWS_ACCOUNT_ID}.dkr.ecr.sa-east-1.amazonaws.com/${REPO}:latest
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.sa-east-1.amazonaws.com/${REPO}:v${VERSION}
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.sa-east-1.amazonaws.com/${REPO}:latest