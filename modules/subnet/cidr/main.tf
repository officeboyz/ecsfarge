locals {
  public_ipv4_cidr = cidrsubnet(var.ipv4_cidr_block, 4, 0)
  private_ipv4_cidr = cidrsubnet(var.ipv4_cidr_block, 4, 15)
  public_ipv6_cidr = cidrsubnet(var.ipv6_cidr_block, 4, 0)
  private_ipv6_cidr = cidrsubnet(var.ipv6_cidr_block, 4, 15)
  subnet_cidrs = {
    for i, az in var.availability_zones : az => {
      public = {
        ipv4_cidr = cidrsubnet(local.public_ipv4_cidr, 4, i)
        ipv6_cidr = cidrsubnet(local.public_ipv6_cidr, 4, i)
      }

      private = {
        ipv4_cidr = cidrsubnet(local.private_ipv4_cidr, 4, i)
        ipv6_cidr = cidrsubnet(local.private_ipv6_cidr, 4, i)
      }
    }
  }
}
