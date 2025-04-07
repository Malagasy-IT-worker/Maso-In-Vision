module "MIV-SERVER" {
  source = "../../Modules/compute_instance"

  instance_name = "MIV-SERVER"
  instance_type = "custom-4-32768"
  zone = "africa-south1-a"
  instance_image = "debian-cloud/debian-11"
  instance_disk_size = "50"

}

module "firewall" {
  source = "../Modules/firewalls"
}