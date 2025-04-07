resource "google_storage_bucket" "terraform-state" {
  name = var.storage_name
  location = var.storage_location
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}