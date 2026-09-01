output "role_arns" {
  description = "Execution role ARNs keyed by the caller-defined role identifier."
  value       = { for key, role in aws_iam_role.this : key => role.arn }
}

output "role_ids" {
  description = "Execution role IDs keyed by the caller-defined role identifier."
  value       = { for key, role in aws_iam_role.this : key => role.id }
}
