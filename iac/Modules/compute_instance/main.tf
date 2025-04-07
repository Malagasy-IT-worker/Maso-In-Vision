
resource "google_compute_instance" "main_server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.instance_disk_size 
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