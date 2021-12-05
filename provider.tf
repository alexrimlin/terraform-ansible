terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.16.0"
        }
    }
}


provider "digitalocean" {}

data "digitalocean_ssh_key" "terraform" {
    name = "${var.digitalocean_ssh_key_name}"
}