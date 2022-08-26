terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }
}

provider "digitalocean" {
    # DigitalOcean Auth Token should be passed in via environment variable.
    # DIGITALOCEAN_TOKEN
}

module "k8s_envs" {
    source = "../../../modules/cloud/digitalocean"

    count = 3

    name = "group-${format("%02d", count.index + 1)}"
    enable_autoscaling = true
    cluster_min_size = 3
    cluster_max_size = 5
    worker_size = "s-1vcpu-2gb"
    ssl = false
}