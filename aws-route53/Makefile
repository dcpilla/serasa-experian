#!make
# Makefile for lazy people
# Dependencies:
# - bash or zsh

CURRENT_DIR        := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST) ) ) )
TERRAFORM_DIR      := "./"
# We like colors
RED                 = `tput setaf 1`
GREEN               = `tput setaf 2`
RESET               = `tput sgr0`
YELLO               = `tput setaf 3`

ifdef ENV
	ENV        := $(ENV)
else
	ENV        := "dev"
endif

ifdef OS
	RM         := $(powershell -noprofile rm ${PWD}\.terraform\ -force -recurse)
else
	ifeq ($(shell uname), Linux)
		RM := rm -rf ${PWD}/.terraform
	endif
endif


.PHONY: help
help: ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docs
docs: ## Generate documentation
	@echo -en "$(GREEN)==> Building $@, hold on!$(RESET)"
	@echo ""
	@terraform-docs -c ${PWD}/.terraform-docs.yml ${PWD}/${TERRAFORM_DIR}/

.PHONY: init
init: ## Initialize terraform
	$(RM)
	@echo -en "$(GREEN)==> Terraform $@ as ${ENV} $(RESET)"
	@cd ${TERRAFORM_DIR} && terraform init -reconfigure -upgrade -lock=false

.PHONY: plan
plan: ## Terraform planning
	@echo -en "$(GREEN)==> Terraform $@ as ${ENV} $(RESET)"
	@cd ${TERRAFORM_DIR} && terraform -chdir=${CURRENT_DIR} plan -refresh=true -lock=false -out=${CURRENT_DIR}/${ENV}.plan

.PHONY: planned
planned: ## Terraform planned
	@echo -en "$(GREEN)==> $@ as ${ENV} $(RESET)"
	@make plan
	@cd  ${TERRAFORM_DIR} && terraform -chdir=${CURRENT_DIR} show -json ${CURRENT_DIR}/${ENV}.plan > ${CURRENT_DIR}/${ENV}.json

.PHONY: destroy 
destroy: ## Terraform DESTROY 
	@echo -en "$(RED)WARNING!!!!$(RESET) $(YELLO)==> DESTROYING Terraform as ${ENV} $(RESET)"
	@cd ${TERRAFORM_DIR} && terraform -chdir=${CURRENT_DIR} destroy -force -lock=false

.PHONY: show
show: ## Terraform show planning
	@echo -en "$(GREEN)==> Terraform $@ as ${ENV} $(RESET)"
	@cd ${TERRAFORM_DIR} && terraform -chdir=${CURRENT_DIR} show

.PHONY: apply 
apply: ## Terraform Apply 
	@echo -en "$(GREEN)==> Terraform $@ as ${ENV} $(RESET)"
	@cd ${TERRAFORM_DIR} && terraform -chdir=${CURRENT_DIR} apply -auto-approve -lock=false

.PHONY: purge
purge: ## Purge .terraform and modules 
	@echo -en "$(GREEN)==> Terraform $@ as ${ENV} $(RESET)"
	$(RM)

.PHONY: check
check: ## Terraform checking (init, plan)
	@make init
	@make plan
