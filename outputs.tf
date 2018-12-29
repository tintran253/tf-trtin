output "ip" {
  value = "${digitalocean_droplet.main.ipv4_address}"
}
