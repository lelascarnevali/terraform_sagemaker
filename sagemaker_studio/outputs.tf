output "sm_domain_id" {
  value = aws_sagemaker_domain.sm_domain.id
}

output "sm_domain_arn" {
  value = aws_sagemaker_domain.sm_domain.arn
}

output "sm_domain_url" {
  value = aws_sagemaker_domain.sm_domain.url
}

output "sm_domain_users" {
  value = aws_sagemaker_user_profile.domain_user[*].id
}

#output "sm_s3_bucket" {
#  value = aws_s3_bucket.sm_bucket.bucket
#}
