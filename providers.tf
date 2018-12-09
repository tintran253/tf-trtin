
provider "digitalocean" {
  token = "${var.do_token}"
}

# provider "mysql" {
#   endpoint = "my-database.example.com:3306"
#   username = "app-user"
#   password = "app-password"
# }
