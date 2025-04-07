terraform {
  backend "gcs" {
    bucket = "ankoay-storage"
    prefix = "terraform-state"
  }
}