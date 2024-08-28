ENV = "dev"

gen-doc:
	@terraform-docs markdown table --output-file README.md .

install: init plan apply 	 

upgrade: plan apply

init:
	@terraform init -backend-config=backend-config/$(ENV).tf

plan:
	@terraform plan --var-file=variables-$(ENV).tfvars -out=$(ENV).plan

apply: gen-doc
	@terraform apply $(ENV).plan

destroy:
	@terraform	  destroy  --var-file=variables-$(ENV).tfvars

comment_backend:
	@sed -i "" 's/^/#/' backend.tf

first-run-init: comment_backend
	@terraform init

first-run-change-to-init-s3: comment_backend
	@sed -i "" 's/bucket  =.*/bucket  ="$(shell terraform show | awk -F"|" '/Bucket TF state/ {print$$3}')"/g' backend-config/$(ENV).tf
	@sed -i "" 's/#//g' backend.tf
	@terraform init -backend-config=backend-config/$(ENV).tf

clean:
	rm -rf .terraform* *.plan *.tmp
