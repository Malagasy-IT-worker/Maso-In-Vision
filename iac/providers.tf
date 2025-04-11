provider "google" {
  credentials = file("./credentials.json")
  project     = "esoalahy"
  region      = "africa-south1"
  zone        = "africa-south1-a"
}
