data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "sm_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com", "glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sm_user_policy" {
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole",
      "sts:GetCallerIdentity"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/sm_user_role"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:*Object"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::sm-bucket-*",
      "arn:aws:s3:::sm-bucket-*/*"
    ]
  }

  statement {
    actions = [
      "sagemaker:DescribeApp",
      "sagemaker:DescribeImageVersion",
      "sagemaker:CreateApp"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "sagemaker:CreateApp",
    ]
    effect = "Deny"
    resources = [
      "*"
    ]
    condition {
      test     = "ForAnyValue:StringNotLike"
      variable = "sagemaker:InstanceTypes"
      values = [
        "ml.t3.medium",
        "ml.c5.large",
        "system"
      ]
    }
  }

  statement {
    actions = [
      "sagemaker:DeleteApp"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTables",
      "glue:GetTable",
      "glue:GetPartitions",
      "glue:GetPartition",
      "glue:SearchTables",
      "glue:GetUserDefinedFunctions",
      "lakeformation:GetResourceLFTags",
      "lakeformation:ListLFTags",
      "lakeformation:GetLFTag",
      "lakeformation:SearchTablesByLFTags",
      "lakeformation:SearchDatabasesByLFTags",
      "lakeformation:GetDataAccess",
      "lakeformation:StartTransaction",
      "lakeformation:CommitTransaction",
      "lakeformation:CancelTransaction",
      "lakeformation:ExtendTransaction",
      "lakeformation:DescribeTransaction",
      "lakeformation:ListTransactions",
      "lakeformation:GetTableObjects",
      "lakeformation:UpdateTableObjects",
      "lakeformation:DeleteObjectsOnCancel"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "elasticmapreduce:*"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}
