# Cloud Landing Zone state storage

This directory contains the S3 buckets used for storing the terraform state for this repo.
Data is automatically replicated to the Backup account.

The corresponding terraform state file for those S3 buckets themselves, will remain in GitHub, as it should not contain any sensitive information.
