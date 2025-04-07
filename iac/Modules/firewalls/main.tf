resource "google_compute_firewall" "allow_custom_port" {
  name    = "allow-custom-port"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"] 
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}