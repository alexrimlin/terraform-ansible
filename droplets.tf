resource "digitalocean_droplet" "web" {
    count   = 1
    image   = "ubuntu-20-04-x64"
    name    = "web-${count.index}"
    region  = "fra1"
    size    = "s-1vcpu-1gb"

    ssh_keys = [
        data.digitalocean_ssh_key.terraform.id
    ]

    provisioner "remote-exec" {
        inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

        connection {
            host        = self.ipv4_address
            type        = "ssh"
            user        = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},'  --private-key=${var.pvt_key} -e 'pub_key=${var.pub_key}' ${var.ansible_playbook_name}"
    }
}

output "droplet_id_addresses" {
    value = {
        for droplet in digitalocean_droplet.web:
        droplet.name => droplet.ipv4_address
    }
}