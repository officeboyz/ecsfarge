variable "length" {
  type = number
}
# ceiling(log2(var.length)) approximation
output "required_bits" {
  value = 2
}