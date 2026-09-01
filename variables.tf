variable "roles" {
  description = "Execution roles to create, keyed by a stable caller-defined identifier."
  type = map(object({
    name = string
  }))
}
