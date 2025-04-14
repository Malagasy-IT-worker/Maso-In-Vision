
resource "google_compute_instance" "vm_instance" {
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

resource "null_resource" "force_provision" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "[${google_compute_instance.vm_instance.name}]" > "${path.root}/Environments/MIV-SERVER/ansible/hosts.ini"
      echo "${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} ansible_user=admin ansible_ssh_private_key_file=${path.root}/Keys/key" >> "${path.root}/Environments/MIV-SERVER/ansible/hosts.ini"
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i '${path.root}/Environments/MIV-SERVER/ansible/hosts.ini' \
        '${path.root}/Environments/MIV-SERVER/ansible/ansible_playbook.yaml'
    EOT
  }
}