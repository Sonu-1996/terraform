#export MONGODB_ATLAS_PUBLIC_KEY="<insert your public key here>"
#export MONGODB_ATLAS_PRIVATE_KEY="<insert your private key here>"

# Create a Project
resource "mongodbatlas_project" "atlas-project" {
 org_id = var.atlas_org_id
 name = var.atlas_project_name
}


# Create a Database User
resource "mongodbatlas_database_user" "db-user" {
 username = "dev-user"
 password = random_password.db-user-password.result
 project_id = mongodbatlas_project.atlas-project.id
 auth_database_name = "admin"
 roles {
   role_name     = "readWrite"
   database_name = "${var.atlas_project_name}-db"
 }
}
# Create a Database Password
resource "random_password" "db-user-password" {
 length = 16
 special = true
 override_special = "_%@"
}

#Next, we need to create the IP access list.

# Create Database IP Access List
resource "mongodbatlas_project_ip_access_list" "ip" {
 project_id = mongodbatlas_project.atlas-project.id
 ip_address = var.ip_address
}

#We will need to put the IP address that we are connecting to the MongoDB Atlas cluster into the terraform.tfvars file.

resource "mongodbatlas_cluster" "test" {
 project_id   = mongodbatlas_project.atlas-project.id
 name         = "${var.atlas_project_name}-${var.environment}-cluster"
 cluster_type = "REPLICASET"
 replication_specs {
   num_shards = 1
   regions_config {
     region_name     = var.atlas_region
     electable_nodes = 3
     priority        = 7
     read_only_nodes = 0
   }
 }
 cloud_backup     = true
 auto_scaling_disk_gb_enabled = true
 mongo_db_major_version       = "7.0"
 # Provider Settings "block"
 provider_name               = var.cloud_provider
#  provider_disk_type_name     = "P6"
 provider_instance_size_name = var.cluster_instance_size_name
}