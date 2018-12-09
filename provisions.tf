resource "null_resource" "__do_action" {
  depends_on = ["digitalocean_droplet.__do"]

  connection {
    host        = "${digitalocean_droplet.__do.ipv4_address}"
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
      "git clone https://github.com/tintran253/tintt-gaubungbu.git",
      "cd tintt-gaubungbu",
      "npm i pm2 -g",
      "npm i",
      "pm2 start ecosystem.config.js",

      # "sudo /bin/systemctl daemon-reload",
      # temporary disable nginx
      "sudo systemctl stop nginx",

      "sudo mysql -e ${data.template_file.pw_cmd.rendered}",
    ]
  }
}
