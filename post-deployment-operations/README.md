# Post deployment operations

This folder helps solving some scenarios where the deployment order creates circle dependencies between accounts. Those scenarios are common deploying Cloud Landing Zones and Terraform helps preventing lots of them, but not all.

- One of the most obvious is centralising the CI/CD permissions on a role on Shared Services that may or may not be present at the time of deployment.
