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
  provisioner "file" {
    content     = "${data.template_file.prod_conf.rendered}"
    destination = "/tmp/config.production.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/config.production.json tintt-gaubungbu",
      "cd tintt-gaubungbu",
      "pm2 start ecosystem.config.js",
      "sudo mysql -uroot -p${var.sql_password} ${var.name} < 'trtin.sql'",
      "sudo systemctl start nginx",
    ]

    # "sudo /bin/systemctl daemon-reload",
    # temporary disable nginx

    # => create database
    # => exec password
    # => pass prod conf
    # "sudo mysql -e ${data.template_file.pw_cmd.rendered}",
  }
}
