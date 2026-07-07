variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Managed by Terraform"
}

variable "trusted_services" {
  description = "List of AWS service principals allowed to assume this role (e.g. ['ec2.amazonaws.com'])"
  type        = list(string)
}

variable "policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
