variable "protocol_port_pairs" {
  type = list(object({
    protocol    = string
    port_number = number
  }))
  description = "List of protocol and port pairs."

  validation {
    condition = alltrue([
      for pair in var.protocol_port_pairs :
      contains(["-1", "tcp", "udp"], pair.protocol) && pair.port_number >= 0 && pair.port_number <= 65535
      ])
    error_message = "Each protocol must be '-1', 'tcp', or 'udp', and port numbers must be between 0 and 65535."
  }
}


variable "nacl_id" { type = string }

variable "cidrs" {
  type = list(object({
    ipv4_cidr = string
    ipv6_cidr = string
  }))
}

variable "ipv4" { type = bool}
variable "ipv6" { type = bool}
variable "initial_offset" {
  type = number
  default = 100
}
module "entropy_calculator" {
  source = "./entropy_calculator"
  length = length(var.protocol_port_pairs)
}
module "cartesian_product" {
  count = length(var.protocol_port_pairs)
  source = "./direction"
  nacl_id     = var.nacl_id
  port_number = var.protocol_port_pairs[count.index].port_number
  protocol    = var.protocol_port_pairs[count.index].protocol
  cidrs = var.cidrs
  offset = count.index + var.initial_offset
  consumed_bits = module.entropy_calculator.required_bits
  ipv4 = var.ipv4
  ipv6 = var.ipv6
}