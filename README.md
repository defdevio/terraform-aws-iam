# terraform-aws-iam

Creates IAM execution roles with the AWS managed Lambda basic execution policy attached.

## Usage

```hcl
module "iam" {
  source = "github.com/defdevio/terraform-aws-iam?ref=v1.2.0"

  account_id = "123456789012"

  roles = {
    application = {
      name = "lambda-execution-application"

      custom_iam_policy_statements = [
        {
          sid       = "AllowBucketRead"
          actions   = ["s3:GetObject"]
          resources = ["arn:aws:s3:::example-bucket/*"]

          conditions = [
            {
              test     = "StringEquals"
              variable = "aws:RequestedRegion"
              values   = ["us-west-2"]
            }
          ]
        }
      ]
    }
  }
}
```

Custom statements are identity-based permissions attached to the role. Each
statement must specify its resources. Principals are not supported because
they belong in resource-based policies or trust relationships.

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `roles` | Execution roles keyed by stable caller-defined identifiers. | `map(object({ name = string }))` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `role_arns` | Role ARNs keyed by the caller-defined identifier. |
| `role_ids` | Role IDs keyed by the caller-defined identifier. |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.84 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID that is allowed to assume the Lambda execution roles. | `string` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | Execution roles to create, keyed by a stable caller-defined identifier. | <pre>map(object({<br/>    name = string<br/>    custom_iam_policy_statements = optional(list(object({<br/>      sid       = optional(string)<br/>      effect    = optional(string, "Allow")<br/>      actions   = set(string)<br/>      resources = set(string)<br/>      conditions = optional(list(object({<br/>        test     = string<br/>        variable = string<br/>        values   = set(string)<br/>      })), [])<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns) | Execution role ARNs keyed by the caller-defined role identifier. |
| <a name="output_role_ids"></a> [role\_ids](#output\_role\_ids) | Execution role IDs keyed by the caller-defined role identifier. |
<!-- END_TF_DOCS -->