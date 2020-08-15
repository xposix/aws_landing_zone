#!/usr/bin/env bash

set -e

## ----------------------------------
# Step #1: Define variables
# ----------------------------------
template_dir="accounts/template"
master_dir="accounts/master"
account_dir="accounts"
organizations_deployer_role="OrganizationAccountAccessRole"

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
  request_values environment_type "What type is this environment? 'live', 'nonlive', 'sandbox', etc"
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
  echo "[FATAL] Invalid account name. Account names accept lowercase alphanumeric with hyphen separators" && exit 1
fi

echo "[INFO] Creating account directory.."
if [ -d "${account_dir}/${account_name}" ]; then
  echo "[FATAL] Account configuration already exists." && exit 1
else
  mkdir ${account_dir}/${account_name}
fi

echo "[INFO] Creating organisation account definition.."
cp ${template_dir}/organisation/account_template.tf ${master_dir}/account_${account_name}.tf
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g" ${master_dir}/account_${account_name}.tf
sed -i '' "s/{ORGANISATIONS_DEPLOYER_ROLE}/${organizations_deployer_role}/g" ${master_dir}/account_${account_name}.tf

echo "[INFO] Creating default terraform backend.."
cp ${template_dir}/account/backend.tf ${account_dir}/${account_name}/backend.tf
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g" ${account_dir}/${account_name}/backend.tf
sed -i '' "s/{ACCOUNT_DIR}/${account_dir}/g" ${account_dir}/${account_name}/backend.tf

echo "[INFO] Creating default terraform IAM.."
cp ${template_dir}/account/iam.tf ${account_dir}/${account_name}/iam.tf

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
cp ${template_dir}/account/vars.tf ${account_dir}/${account_name}/vars.tf
sed -i '' "s/{ACCOUNT_NAME}/${account_name}/g" ${account_dir}/${account_name}/vars.tf
sed -i '' "s/{ORGANISATIONS_DEPLOYER_ROLE}/${organizations_deployer_role}/g" ${account_dir}/${account_name}/vars.tf
sed -i '' "s/{DNS_SUBDOMAIN}/${dns_subdomain}/g" ${account_dir}/${account_name}/vars.tf
sed -i '' "s/{NUMBER_OF_AZS}/${number_of_azs}/g" ${account_dir}/${account_name}/vars.tf
sed -i '' "s;{VPC_CIDR};${vpc_cidr};g" ${account_dir}/${account_name}/vars.tf
sed -i '' "s/{ENVIRONMENT_TYPE}/${environment_type}/g" ${account_dir}/${account_name}/vars.tf
