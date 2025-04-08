module "storage" {
    source = "./Modules/storage"
    storage_name = "miv-storage"
    storage_location = "africa-south1"
}

module "MIV-SERVER" {
  source = "./Environments/MIV-SERVER"
}
