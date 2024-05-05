output "cidr_map" {
  value = local.subnet_cidrs
}
output "subnet_blocks" {
  value = {
    public = {
      ipv6 = local.public_ipv6_cidr
      ipv4 = local.public_ipv4_cidr
    }
    private = {
      ipv6 = local.private_ipv6_cidr
      ipv4 = local.private_ipv4_cidr
    }
  }
}