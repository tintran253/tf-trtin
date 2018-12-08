resource "null_resource" "graylog" {
  depends_on = ["digitalocean_droplet.graylog"]

  connection {
    host        = "${digitalocean_droplet.graylog.ipv4_address}"
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  # put elastic config file
  provisioner "file" {
    content     = "${data.template_file.nginx.rendered}"
    destination = "/etc/nginx/sites-available/default"
  }

  provisioner "remote-exec" {
    inline = [
      # "sudo /bin/systemctl daemon-reload",
      # temporary disable nginx
      "sudo systemctl stop nginx",
    ]
  }
}
