### DOMAIN SETTINGS ###
resource "aws_sagemaker_studio_lifecycle_config" "auto_shutdown" {
  studio_lifecycle_config_name     = "auto-shutdown"
  studio_lifecycle_config_app_type = "JupyterServer"
  studio_lifecycle_config_content  = filebase64("${path.module}/scripts/auto-shutdown.sh")
}

resource "aws_sagemaker_domain" "sm_domain" {
  domain_name = var.domain_name
  #auth_mode   = "IAM"
  auth_mode               = "SSO"
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  app_network_access_type = "PublicInternetOnly" #"VpcOnly"
#  domain_settings {
#    security_group_ids = var.security_group_ids
#  }
  default_user_settings {
    execution_role  = var.arn_exec_role #aws_iam_role.sm_domain_role.arn
#    security_groups = var.security_group_ids
   jupyter_server_app_settings {
     lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.auto_shutdown.arn]
   }
  }
}

#resource "aws_iam_role" "sm_domain_role" {
#  name               = "sm_domain_role"
#  path               = "/"
#  assume_role_policy = data.aws_iam_policy_document.sm_policy.json
#}

#resource "random_id" "sm_bucket_id" {
#  byte_length = 8
#}
#
#resource "aws_s3_bucket" "sm_bucket" {
#  bucket = "sm-bucket-${random_id.sm_bucket_id.dec}"
#}


### USER SETTINGS ###
resource "aws_sagemaker_user_profile" "domain_user" {
  domain_id                      = aws_sagemaker_domain.sm_domain.id
  count                          = length(var.user_names)
  user_profile_name              = replace(var.user_names[count.index],".","-")
  single_sign_on_user_identifier = "UserName"
  single_sign_on_user_value      = var.user_names[count.index]
  user_settings {
    execution_role = var.arn_exec_role #aws_iam_role.sm_user_role.arn
  }
}

#resource "aws_iam_policy" "sm_user_policy" {
#  name   = "sm_user_policy"
#  path   = "/"
#  policy = data.aws_iam_policy_document.sm_user_policy.json
#}
#
#resource "aws_iam_role" "sm_user_role" {
#  name               = "sm_user_role"
#  path               = "/"
#  assume_role_policy = data.aws_iam_policy_document.sm_policy.json
#  managed_policy_arns = [
#    "arn:aws:iam::aws:policy/service-role/AwsGlueSessionUserRestrictedServiceRole",
#    aws_iam_policy.sm_user_policy.arn
#  ]
#}

# Start Sagemaker Studio Jupyter
resource "aws_sagemaker_app" "jupyter" {
  domain_id         = aws_sagemaker_domain.sm_domain.id
  count             = length(var.user_names)
  user_profile_name = aws_sagemaker_user_profile.domain_user[count.index].user_profile_name
  app_name          = "default"
  app_type          = "JupyterServer"
  resource_spec {
    lifecycle_config_arn = aws_sagemaker_studio_lifecycle_config.auto_shutdown.arn
    instance_type        = "system"
  }
}
##
## Start Kernel to run notebooks
resource "aws_sagemaker_app" "notebook_kernel" {
  domain_id         = aws_sagemaker_domain.sm_domain.id
  count             = length(var.user_names)
  user_profile_name = aws_sagemaker_user_profile.domain_user[count.index].user_profile_name
  app_name          = "kernel-notebook"
  app_type          = "KernelGateway"
  resource_spec {
    instance_type       = "ml.t3.medium"
    sagemaker_image_arn = "arn:aws:sagemaker:us-east-1:081325390199:image/sagemaker-data-science-310-v1"

  }
}
