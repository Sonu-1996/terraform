variable "project-id" {
  type = string
  default = ""

}

variable "region" {
  type = string
  default = ""
}

variable "zone" {
  type = string
  default = ""
}

################# mongo DB ##############
# Atlas Organization ID
variable "atlas_org_id" {
 type        = string
 description = "Atlas Organization ID"
}
# Atlas Project Name
variable "atlas_project_name" {
 type        = string
 description = "Atlas Project Name"
}
# Atlas Project Environment
 variable "environment" {
   type        = string
   description = "The environment to be built"

 }
# Cluster Instance Size Name
variable "cluster_instance_size_name" {
 type        = string
 description = "Cluster instance size name"
 default = "M20"
}
# Cloud Provider to Host Atlas Cluster
variable "cloud_provider" {
 type        = string
 description = "AWS or GCP or Azure"
 default = "GCP"
}
# Atlas Region
variable "atlas_region" {
 type        = string
 description = "Atlas region where resources will be created"
 default = "asia-south2"
}
# MongoDB Version
variable "mongodb_version" {
 type        = string
 description = "MongoDB Version"
}
# IP Address Access
variable "ip_address" {
 type = string
 description = "IP address used to access Atlas cluster"
}

##############################################################