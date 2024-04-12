#!/bin/bash
# Write a bash script that deletes all the security group rules in the default security group 
# in all the VPCs in all the regions of a specific AWS account.

# Print the IAM alias of the account
echo "++++++ Processing $(aws iam list-account-aliases --query 'AccountAliases[0]') account ++++++"

# List all regions
regions=$(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text)

for region in $regions
do
    echo "Processing region: $region"

    # List all VPCs
    vpcs=$(aws ec2 describe-vpcs --region $region --query "Vpcs[].{Id:VpcId}" --output text)

    for vpc in $vpcs
    do
        echo "Processing VPC: $vpc"

        # Find default security group
        default_sg=$(aws ec2 describe-security-groups --region $region --filters Name=vpc-id,Values=$vpc Name=group-name,Values='default' --query 'SecurityGroups[0].GroupId' --output text)

        if [ "$default_sg" != "None" ]; then
            echo "++ Processing default security group: $default_sg"

            # List all ingress rules
            ingress_rules=$(aws ec2 describe-security-groups --region $region --group-ids $default_sg --query 'SecurityGroups[0].IpPermissions[]' --output json)

            # Remove all ingress rules
            if [ "$ingress_rules" != "[]" ]; then
                aws ec2 revoke-security-group-ingress --region $region --group-id $default_sg --ip-permissions "$ingress_rules"
            else
                echo "No ingress rules found for this default security group"
            fi

            # List all egress rules
            egress_rules=$(aws ec2 describe-security-groups --region $region --group-ids $default_sg --query 'SecurityGroups[0].IpPermissionsEgress[]' --output json)

            # Remove all egress rules
            if [ "$egress_rules" != "[]" ]; then
                aws ec2 revoke-security-group-egress --region $region --group-id $default_sg --ip-permissions "$egress_rules"
            else
                echo "No egress rules found for this default security group"
            fi

            echo "++ Completed processing default security group: $default_sg"
        else
            echo "No default security group found for VPC: $vpc"
        fi
    done

    echo "Completed processing region: $region"
done
