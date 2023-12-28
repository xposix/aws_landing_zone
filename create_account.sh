#!/bin/bash

set -e

## ----------------------------------
# Step #1: Define variables
# ----------------------------------
template_dir="accounts/template"
management_dir="accounts/management"
account_dir="accounts"
organizations_deployer_role="OrganizationAccountAccessRole"

# TO_FILL Hardcoded values that will never change for this company
account_alias_prefix="mycompany"
company_email_domain="mycompany.domain"
company_route53_domain="mycompany.com."

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
request_values() {
  echo "> $2 :"
  read "$1"
}

confirm(){
  cat <<EOM
--------

Please ensure that all the values are correct and enter 'yes' to proceed...
EOM
  read fackEnterKey
  if [ "$fackEnterKey" != "yes" ]; then
    echo "Cancelling process..."
    exit
  fi
}
 
# function to display wizard
start_wizard() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " CLZ - Account Creator"
	echo "~~~~~~~~~~~~~~~~~~~~~~~"
  request_values account_name "Enter the name of the account, accept lowercase alphanumeric with hyphen separators"
  request_values dns_subdomain "Enter the DNS subdomain without trailing dots, e.g: 'sandbox'"
  request_values number_of_azs "How many Availability Zones to use 2 or 3?"
  request_values vpc_cidr "CIDR given to the VPC"
  request_values environment_type "What type is this environment? (e.g.: 'live', 'nonlive', 'sandbox'): "
  confirm
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------

start_wizard

if [[ ${account_name} =~ ^[a-z0-9_]+$ ]]; then
  echo "[INFO] Account name is ${account_name}"
else
  echo "[FATAL] Invalid account name. Account names accept lowercase alphanumeric with lowercase separators" && exit 1
fi

echo "[INFO] Creating account directory.."
if [ -d "${account_dir}/${account_name}" ]; then
  echo "[FATAL] Account configuration already exists." && exit 1
else
  mkdir ${account_dir}/${account_name}
fi

primary_region=$(cat ./general.tfvars | grep primary_region | awk '{print $3}' | sed 's/"//g')

echo "[INFO] Creating organisation account definition.."
destination_file="${management_dir}/account_${account_name}.tf"
cp ${template_dir}/organisation/account_template.tf ${destination_file}
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g"                               ${destination_file}
sed -i '' "s/{ORGANISATIONS_DEPLOYER_ROLE}/${organizations_deployer_role}/g" ${destination_file}
sed -i '' "s/{COMPANY_EMAIL_DOMAIN}/${company_email_domain}/g"               ${destination_file}

echo "[INFO] Creating default terraform backend.."
destination_file="${account_dir}/${account_name}/backend.tf"
cp ${template_dir}/account/backend.tf ${destination_file}
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g"             ${destination_file}
sed -i '' "s/{ACCOUNT_DIR}/${account_dir}/g"               ${destination_file}
sed -i '' "s/{PRIMARY_REGION}/${primary_region}/g"         ${destination_file}

echo "[INFO] Creating default terraform IAM.."
cp ${template_dir}/account/iam.tf ${account_dir}/${account_name}/iam.tf
sed -i '' "s/{ACCOUNT_ALIAS_PREFIX}/${account_alias_prefix}/g"        ${destination_file}

echo "[INFO] Creating locals file.."
cp ${template_dir}/account/_locals.tf ${account_dir}/${account_name}/_locals.tf

echo "[INFO] Creating default terraform for AWS Config.."
cp ${template_dir}/account/awsconfig.tf ${account_dir}/${account_name}/awsconfig.tf

echo "[INFO] Creating default terraform network.."
cp ${template_dir}/account/networking.tf ${account_dir}/${account_name}/networking.tf

echo "[INFO] Creating default terraform Route53 configuration.."
cp ${template_dir}/account/r53.tf ${account_dir}/${account_name}/r53.tf

echo "[INFO] Creating default terraform S3 bucket.."
cp ${template_dir}/account/s3.tf ${account_dir}/${account_name}/s3.tf

echo "[INFO] Creating default terraform provider.."
cp ${template_dir}/account/provider.tf ${account_dir}/${account_name}/provider.tf

echo "[INFO] Creating default terraform variables.."
destination_file="${account_dir}/${account_name}/variables.tf"
cp ${template_dir}/account/variables.tf ${destination_file}

destination_file="${account_dir}/${account_name}/_locals.tf"
cp ${template_dir}/account/_locals.tf ${destination_file}
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g"                        ${destination_file}
sed -i '' "s/{ORGANISATIONS_DEPLOYER_ROLE}/${organizations_deployer_role}/g"      ${destination_file}
sed -i '' "s/{COMPANY_ROUTE53_DOMAIN}/${company_route53_domain}/g"    ${destination_file}
sed -i '' "s/{DNS_SUBDOMAIN}/${dns_subdomain}/g"                      ${destination_file}
sed -i '' "s/{NUMBER_OF_AZS}/${number_of_azs}/g"                      ${destination_file}
sed -i '' "s;{VPC_CIDR};${vpc_cidr};g"                                ${destination_file}
sed -i '' "s/{ENVIRONMENT_TYPE}/${environment_type}/g"                ${destination_file}
sed -i '' "s/{PRIMARY_REGION}/${primary_region}/g"                    ${destination_file}

echo "[INFO] Copying the rest of the files.."
cp ${template_dir}/account/Makefile ${account_dir}/${account_name}/Makefile