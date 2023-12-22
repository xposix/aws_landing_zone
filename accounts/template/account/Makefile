# Copyright 2016 Philip G. Porada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
BLACK=$(shell tput setaf 0)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
BLUE=$(shell tput setaf 4)
WHITEBG=$(shell tput setab 7)
RESET=$(shell tput sgr0)

SHELL:=/bin/bash

export ACCOUNT_ID := $(shell aws sts get-caller-identity --query 'Account' --output text)

.PHONY: apply plan prep
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prep:
	@echo
	@echo
	@echo "$(BOLD)$(BLUE)#################################$(RESET) BEGIN $(CURRENT_FOLDER) $(BOLD)$(BLUE)##################################$(RESET)"

init: prep ## Initialises Terraform on this directory.
	terraform init ${EXTRA_INIT_FLAGS} \
		-lock=true \
		-backend-config="bucket=clz-terraform-state-${ACCOUNT_ID}" \
		-input=false
	@echo
	@echo "$(BLUE)##################################$(RESET) END $(CURRENT_FOLDER) $(BOLD)$(BLUE)################################## $(RESET)"

plan: prep ## Show what terraform thinks it will do
	terraform plan \
		-lock=true \
		-input=false \
		-var-file="../../general.tfvars" \
		-compact-warnings \
		-refresh=true
	@echo "$(BOLD)$(BLUE)##################################$(RESET) END $(CURRENT_FOLDER) $(BOLD)$(BLUE)################################## $(RESET)"

apply: prep ## Have terraform do the things. This will cost money.
	terraform apply -auto-approve \
		-lock=true \
		-var-file="../../general.tfvars" \
		-compact-warnings \
		-refresh=true
	@echo "$(BOLD)$(BLUE)##################################$(RESET) END $(CURRENT_FOLDER) $(BOLD)$(BLUE)################################## $(RESET)"

