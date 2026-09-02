variable "account_id" {
  description = "AWS account ID that is allowed to assume the Lambda execution roles."
  type        = string
}

variable "roles" {
  description = "Execution roles to create, keyed by a stable caller-defined identifier."
  type = map(object({
    name = string
    custom_iam_policy_statements = optional(list(object({
      sid       = optional(string)
      effect    = optional(string, "Allow")
      actions   = set(string)
      resources = set(string)
      conditions = optional(list(object({
        test     = string
        variable = string
        values   = set(string)
      })), [])
    })), [])
  }))
}
