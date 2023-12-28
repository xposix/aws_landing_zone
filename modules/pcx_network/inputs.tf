locals {
  is_spoke = var.vpc_id_to_peer_to == "" ? false : true
}

variable "region" {
  description = "Target region for this deployment"
  type        = string
}

variable "vpc_name" {
  description = "Name of this VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "IP address range for this VPC"
  type        = string
}

variable "vpc_id_to_peer_to" {
  description = "The VPC ID to peer this new VPC with"
  type        = string
  default     = ""
}

variable "peer_to_region" {
  description = "Region holding the VPC to peer to (if relevant)"
  type        = string
  default     = ""
}

variable "owner_of_vpc_to_peer_to" {
  description = "The VPC to peer to, belongs to this account ID"
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

variable "private_endpoints_to_enable" {
  type        = list(string)
  default     = []
  description = "What endpoints to enable, look around the vpc.tf ~ line 54 for possible values."
}

variable "single_nat_gateway" {
  description = "Use only one NAT gateway on the VPC instead of one per Availability Zone"
  type        = bool
  default     = false
}

variable "project_tags" {
  type        = map(any)
  description = "A key/value map containing tags to add to all resources"
}

variable "public_subnet_tags" {
  type        = map(any)
  description = "A key/value map containing additional tags to add to the public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "A key/value map containing additional tags to add to the private subnets"
  default     = {}
}
