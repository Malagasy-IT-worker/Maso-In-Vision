module "miv_server" {
  source = "../../Modules/compute_instance"

  instance_name = "maso-in-vision"
  instance_type = "e2-standard-2"
  zone = "africa-south1-a"
  instance_image = "debian-cloud/debian-11"
  instance_disk_size = "50"

}

module "firewall" {
  source = "../../Modules/firewalls"
}
