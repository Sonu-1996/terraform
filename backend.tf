terraform {
  backend "gcs" {
    bucket = "dev-vihaan-terraform-remote-backend"
    prefix = "terraform/state/env/dev"
  }
}