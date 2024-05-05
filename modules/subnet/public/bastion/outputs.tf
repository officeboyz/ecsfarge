output "bastion_host_public_ips" {
  value = data.aws_instances.bastion_host.public_ips
}
