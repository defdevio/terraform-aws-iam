data "aws_iam_policy_document" "lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

locals {
  custom_policy_roles = {
    for key, role in var.roles : key => role
    if length(role.custom_iam_policy_statements) > 0
  }
}

data "aws_iam_policy_document" "custom" {
  for_each = local.custom_policy_roles

  dynamic "statement" {
    for_each = each.value.custom_iam_policy_statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.conditions

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  for_each           = var.roles
  name               = each.value.name
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  for_each   = var.roles
  role       = aws_iam_role.this[each.key].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "custom" {
  for_each = local.custom_policy_roles

  name   = "custom-${each.key}"
  policy = data.aws_iam_policy_document.custom[each.key].json
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = local.custom_policy_roles

  role       = aws_iam_role.this[each.key].id
  policy_arn = aws_iam_policy.custom[each.key].arn
}
