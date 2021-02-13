# Post deployment operations

This folder solves the problem where any of the IAM roles were deployed if the
EKS cluster in Shared Services was not deployed. Obviously, this presented
challenges when that cluster was not present, affecting the foundation of
the CLZ across all the project accounts.

By using the approach used in this folder, the roles dependent on Jenkins will
be deployed separately to the CLZ foundation.
