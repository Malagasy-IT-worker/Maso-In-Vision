output "MIV-SERVER-IP" {
  description = "MIV server ip"
  value       = module.compute_instance.public_ip
}