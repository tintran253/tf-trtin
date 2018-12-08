resource "digitalocean_droplet" "${var.name}" {
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
    ]
  }
}
