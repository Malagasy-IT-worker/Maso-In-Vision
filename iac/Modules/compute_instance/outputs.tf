output "public_ip"{
  description = "Adresse IP publique de l'instance"
  value       = google_compute_instance.main_server.public_ip
}
