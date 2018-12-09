output "ip" {
  value = "${digitalocean_droplet.__do.ipv4_address}"
}
