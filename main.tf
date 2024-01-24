# EMR pre-requisites to use with SageMaker: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-notebooks-emr-cluster.html

#module "spark_vpc" {
#  source = "terraform-aws-modules/vpc/aws"
#  name   = "vpc_spark"
#  cidr   = "192.142.0.0/16"
#
#  enable_dns_hostnames = true
#  enable_dns_support   = true
#
#  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#  private_subnets = ["192.142.0.0/24", "192.142.1.0/24", "192.142.2.0/24"]
#  public_subnets  = ["192.142.3.0/24", "192.142.4.0/24", "192.142.5.0/24"]
#
#  enable_nat_gateway = true
#}
#
#resource "aws_security_group" "spark_sg" {
#  name   = "spark-sg"
#  vpc_id = module.spark_vpc.vpc_id
#  ingress = [
#    {
#      cidr_blocks      = []
#      description      = "TCP all self"
#      from_port        = 0
#      ipv6_cidr_blocks = []
#      prefix_list_ids  = []
#      protocol         = "-1"
#      security_groups  = []
#      self             = true
#      to_port          = 0
#    }
#  ]
#  egress = [
#    {
#      cidr_blocks      = ["0.0.0.0/0"]
#      description      = "All"
#      from_port        = 0
#      ipv6_cidr_blocks = ["::/0"]
#      prefix_list_ids  = []
#      protocol         = "-1"
#      security_groups  = []
#      self             = true
#      to_port          = 0
#    }
#  ]
#  tags = {
#    "Name" = "spark-sg"
#  }
#}

module "sagemaker_studio" {
  source             = "./modules/sagemaker_studio"
  domain_name        = "domain-test"
  vpc_id             = "vpc-082a3dcfed2ff0069"
  subnet_ids         = ["subnet-0dedda92fd93398af", "subnet-002cc404a89a8b0c0"]
  user_names         = ["leandro.carnevali"]
  arn_exec_role      = "arn:aws:iam::163984801326:role/service-role/AmazonSageMaker-ExecutionRole-20210720T111583"
}

# module "emr_cluster" {
#   source               = "./modules/emr_cluster"
#   cluster_name         = "cluster-test"
#   cluster_applications = ["Spark", "Livy"]
#   subnet_id            = module.spark_vpc.private_subnets[0]
#   security_group_ids   = aws_security_group.spark_sg.id
# }
