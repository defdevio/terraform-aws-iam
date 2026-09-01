# terraform-aws-iam

Creates IAM execution roles with the AWS managed Lambda basic execution policy attached.

## Usage

```hcl
module "iam" {
  source = "github.com/defdevio/terraform-aws-iam?ref=v1.0.0"

  roles = {
    application = {
      name = "lambda-execution-application"
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `roles` | Execution roles keyed by stable caller-defined identifiers. | `map(object({ name = string }))` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `role_arns` | Role ARNs keyed by the caller-defined identifier. |
| `role_ids` | Role IDs keyed by the caller-defined identifier. |
