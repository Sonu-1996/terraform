terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.7.0"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "=1.16.0"
    }
  }
}

provider "google" {
  project     =  var.project-id
  region      =  var.region
  zone        =  var.zone

}