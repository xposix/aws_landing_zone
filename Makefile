# Everything @makefile

export EXTRA_INIT_FLAGS:="-upgrade"

.PHONY: apply plan init

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Performs a Terraform Init across all the accounts
	@make -C accounts/master init
	@make -C accounts/audit init
	@make -C accounts/backup init
	@make -C accounts/network init
	@make -C accounts/shared_services_live init
	@make -C accounts/shared_services_nonlive init
	@make -C post-deployment-operations init

init-upgrade: ## Performs a Terraform init-upgrade across all the accounts
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/master init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/audit init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/backup init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/network init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/shared_services_live init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C accounts/shared_services_nonlive init
	@EXTRA_INIT_FLAGS="$$EXTRA_INIT_FLAGS" make -C post-deployment-operations init

plan: ## Plans for changes across all the accounts in the CLZ
	@make -C accounts/master plan 
	@make -C accounts/audit plan 
	@make -C accounts/master plan 
	@make -C accounts/network plan 
	@make -C accounts/shared_services_live plan 
	@make -C accounts/shared_services_nonlive plan 
	@make -C post-deployment-operations plan

apply: ## Deploys all the changes across all the accounts in the CLZ
	@make -C accounts/master apply
	@make -C accounts/audit apply
	@make -C accounts/backup apply
	@make -C accounts/network apply
	@make -C accounts/shared_services_live apply 
	@make -C accounts/shared_services_nonlive apply 
	@make -C post-deployment-operations apply

	
