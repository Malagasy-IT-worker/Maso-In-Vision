
resource "google_compute_instance" "main_server" {
  name         = "MIV-SERVER"
  machine_type = "custom-4-32768"
  zone         = "africa-south1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 50 
    }
  }

  network_interface {
    network       = "default"
    access_config {} 
  }

  metadata = {
    ssh-keys = "admin:${file("./Keys/key.pub")}"
  }
}