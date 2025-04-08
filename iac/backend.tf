terraform {
  backend "gcs" {
    bucket = "miv-storage"
    prefix = "terraform-state"
    credentials = "./credentials.json"
  }
}
#
