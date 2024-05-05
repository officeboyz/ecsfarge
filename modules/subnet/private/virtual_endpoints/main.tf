# # ECR API Endpoint
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id             = var.vpc_id
#   service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = var.subnet_ids
#   security_group_ids = [var.security_group_for_endpoint_policies]
#
#   private_dns_enabled = true
# }
#
# # ECR Docker Registry Endpoint
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id             = var.vpc_id
#   service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = var.subnet_ids
#   security_group_ids = [var.security_group_for_endpoint_policies]
#
#   private_dns_enabled = true
# }
#
# # S3 Endpoint (Gateway Endpoint)
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id             = var.vpc_id
#   service_name       = "com.amazonaws.${var.aws_region}.s3"
#   vpc_endpoint_type  = "Gateway"
# }
#
# resource "aws_vpc_endpoint" "cloudwatch_logs" {
#   vpc_id             = var.vpc_id
#   service_name       = "com.amazonaws.${var.aws_region}.logs"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = var.subnet_ids
#   security_group_ids = [var.security_group_for_endpoint_policies]
#
#   private_dns_enabled = true
# }
