data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "emr_cluster_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "emr_policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateSecurityGroup"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "emr_instance_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole",
      "sts:GetCallerIdentity"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/emr_instance_role"
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
}

data "template_file" "cluster_configuration" {
  template = file("${path.module}/templates/configuration.json.tpl")
}
