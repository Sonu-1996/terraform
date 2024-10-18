resource "google_compute_network" "dev-vihaan" {

  name                    = "vihaan-dev"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "sunetwork-mumbai-dev" {

  name          = "mumbai-subnetwork-dev"
  ip_cidr_range = "10.0.0.0/24"
  region        = "asia-south1"
  network       = google_compute_network.dev-vihaan.id
}

resource "google_compute_firewall" "allow_ssh" {
  name = "allow-ssh-dev"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.dev-vihaan.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_container_cluster" "dev" {
  name               = "dev"
  location           = "asia-south1-a"
  initial_node_count = 1
  
  network = google_compute_network.dev-vihaan.id
  subnetwork = google_compute_subnetwork.sunetwork-mumbai-dev.id
  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection      = true

  node_config {
    disk_size_gb = 50
    disk_type    = "pd-balanced"
    image_type   = "COS_CONTAINERD"
    machine_type = "e2-standard-2"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]

  }

  
  release_channel {
    channel = "UNSPECIFIED"
  }

  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }


ip_allocation_policy {
  
  stack_type = "IPV4"
  cluster_ipv4_cidr_block = "10.96.0.0/14"
  services_ipv4_cidr_block = "192.168.0.0/16"

}

  master_authorized_networks_config  {

    gcp_public_cidrs_access_enabled = true
    
    cidr_blocks {
     
      cidr_block = "103.205.152.154/32"
    
    }

  }



  addons_config {

    http_load_balancing {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    dns_cache_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {

      enabled = true
    }

  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }


  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  
  

  network_policy {
    enabled  = true
    provider = "PROVIDER_UNSPECIFIED"
  }

depends_on = [ google_compute_network.dev-vihaan ]
  


}



resource "google_container_node_pool" "primary_preemptible_nodes" {

  name       = "my-node-pool"
  cluster    = google_container_cluster.default.id
  node_count = 1
  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  autoscaling {
    min_node_count       = 1
    max_node_count       = 2
    location_policy      = "BALANCED"
  }

  management {
    auto_upgrade = false
  }

  network_config {
    enable_private_nodes = true
  }

}
