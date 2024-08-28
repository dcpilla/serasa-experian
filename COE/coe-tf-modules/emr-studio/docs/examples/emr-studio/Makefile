ENV = "dev"
APPLICATION = "default"
FILE_NAME = $(ENV)

ifneq ($(APPLICATION),"default")
  FILE_NAME=$(APPLICATION)-$(ENV)
endif

$(info ******** Working on $(APPLICATION) Application at $(ENV) env ********)

gen-doc:
	@terraform-docs markdown table --output-file README.md .

install: init plan apply
init: clean init_run	 

upgrade: plan apply

init_run:
	@terraform init -backend-config=backend-config/$(FILE_NAME).tf

git-commit:
	@git add .
	@git commit || true

pre-plan:
	@terraform validate
	@terraform fmt

plan: pre-plan
	@terraform plan --var-file=variables-$(ENV).tfvars -out=$(ENV).plan
	@terraform show -json $(ENV).plan | terraform-j2md > plan-$(ENV).md

apply: gen-doc
	@terraform apply $(ENV).plan

plan-apply: gen-doc plan apply 

destroy:
	@terraform destroy  --var-file=variables-$(FILE_NAME).tfvars

clean:
	rm -rf .terraform *.plan *.tmp
