# Cloud Storage Bucket to store the terraform state files 
resource "google_storage_bucket" "dev-terrafrom-state-bucket" {
   name = "dev-vihaan-terraform-remote-backend"
   location = "asia"
   force_destroy = false
   public_access_prevention    = "enforced"
   uniform_bucket_level_access = true

   versioning {
    enabled = true
   }

}