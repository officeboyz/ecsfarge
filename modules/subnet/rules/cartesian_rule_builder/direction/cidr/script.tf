
variable "nacl_id" { type = string }
variable "cidrs" {
  type = list(object({
    ipv4_cidr = string
    ipv6_cidr = string
  }))
}

variable "protocol" {
  type        = string
}

variable "port_number" {
  type        = number
}
variable "egress" {
  type = bool
}
variable "offset" {
  type = number
}
variable "consumed_bits" {
  type = number
}

variable "ipv4" { type = bool}
variable "ipv6" { type = bool}
module "entropy_calculator" {
  source = "../../entropy_calculator"
  length = length(var.cidrs)
}
module "by_address_protocol" {
  count = length(var.cidrs)
  source = "./address_protocol"
  egress = var.egress
  nacl_id = var.nacl_id
  port_number = var.port_number
  protocol = var.protocol
  cidrs = var.cidrs[count.index]
  offset = var.offset + ( count.index * pow(2, var.consumed_bits))
  consumed_bits = var.consumed_bits + module.entropy_calculator.required_bits
  ipv4 = var.ipv4
  ipv6 = var.ipv6
}