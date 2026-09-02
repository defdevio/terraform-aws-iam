variable "account_id" {
  description = "AWS account ID that is allowed to assume the Lambda execution roles."
  type        = string
}

variable "roles" {
  description = "Execution roles to create, keyed by a stable caller-defined identifier."
  type = map(object({
    name = string
  }))
}
