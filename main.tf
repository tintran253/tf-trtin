resource "digitalocean_droplet" "main" {
  image              = "ubuntu-18-10-x64"
  name               = "${var.name}"
  region             = "sgp1"
  size               = "1gb"
  private_networking = false
  backups            = false
  tags               = ["trtin-gbb"]

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
      "sudo apt-get install -y nodejs",
      "git clone https://github.com/tintran253/tintt-gaubungbu.git",
      "cd tintt-gaubungbu",
      "npm i pm2 -g",
      "npm i",
    ]
  }
}
