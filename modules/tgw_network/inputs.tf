locals {
  enable_tgw_connectivity = var.connectivity_type == "tgw" ? true : false
  enable_local_nats       = var.connectivity_type == "local_internet" ? true : false
  ## To be implemented:
  enable_endpoints = var.connectivity_type == "no_internet" ? true : false
}

variable "connectivity_type" {
  type        = string
  description = <<EOD
  What type of connectivity to configure on that VPC?
   *  tgw: connected to the Transit Gateway in that Region
   *  local_internet: NAT Gateways will be created to have local Internet access
   *  no_internet: No Internet access configured. Only instances deployed in the public subnets will be connected to Internet.
EOD
  default     = false
}

variable "vpc_name" {
  description = "Name of this VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "IP address range for this VPC"
  type        = string
}

variable "n_of_AZs" {
  description = "Number of Availability Zones to deploy this VPC across"
  type        = number
  validation {
    condition     = var.n_of_AZs == 2 || var.n_of_AZs == 3
    error_message = "The number of Availability Zones must be either two or three."
  }
}

variable "project_tags" {
  type        = map
  description = "A key/value map containing tags to add to all resources"
}

variable "public_subnet_tags" {
  type        = map
  description = "A key/value map containing additional tags to add to the public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map
  description = "A key/value map containing additional tags to add to the private subnets"
  default     = {}
}
