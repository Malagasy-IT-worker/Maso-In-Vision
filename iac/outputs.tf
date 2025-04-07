output "instance_ip" {
    value = [for i in google_compute_instance.vm_instance: i.network_interface[0].access_config[0].nat_ip  ]
}
