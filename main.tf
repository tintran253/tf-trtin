resource "digitalocean_droplet" "__do" {
  image              = "ubuntu-18-10-x64"
  name               = "${var.name}"
  region             = "sgp1"
  size               = "4gb"
  private_networking = true
  backups            = true

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      # install nginx
      "sudo apt-get update",

      "sudo apt-get -y install nginx",
      "sudo ufw allow 'Nginx Full'",
      "sudo apt-get -y install mysql-server",
      "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash",
      "sudo apt-get install -y nodejs"
    ]
  }
}
