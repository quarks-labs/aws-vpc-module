data "aws_availability_zones" "available" {}

################################################################################
# Local Vars
################################################################################


locals {
  name   = "${var.name}-${random_string.sufix.result}"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = merge(
  { name    = local.name },
    var.tags, 
  )
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../"
  name = local.name
  cidr = var.vpc_cidr
  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  tags = local.tags
}
