output "MIV-SERVER-IP" {
  description = "value of MIV server ip"
  value       = module.compute_instance.public_ip
}