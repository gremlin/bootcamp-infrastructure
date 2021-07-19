
module "digitalocean" {
  source = "./modules/cloud/digitalocean"

  # Pass variables
  group_id = var.group_id
}