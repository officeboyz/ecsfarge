variable "cidrs" {
  type = list(object({
    ipv4_cidr = string
    ipv6_cidr = string
  }))
}


variable "nacl_id" { type = string }
variable "protocol" { type= string }

variable "port_number" { type= number }
variable "consumed_bits" { type = number}
variable "offset" {  type = number}
variable "ipv4" { type = bool}
variable "ipv6" { type = bool}

locals {
  direction_map = {
    egress = true
    ingress = false
  }
}
module "by_cidr" {
  for_each = local.direction_map
  egress = each.value
  source = "./cidr"
  cidrs = var.cidrs
  nacl_id = var.nacl_id
  port_number = var.port_number
  protocol = var.protocol
  offset = var.offset + (each.value? 0: pow(2, var.consumed_bits))
  consumed_bits = var.consumed_bits + 1 # true/false takes only 1 bit
  ipv4 = var.ipv4
  ipv6 = var.ipv6
}