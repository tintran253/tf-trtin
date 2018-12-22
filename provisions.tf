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
  provisioner "file" {
    content     = "${data.template_file.mysql_conf.rendered}"
    destination = "/etc/mysql/mysql.conf.d/mysqld.cnf"
  }

  provisioner "remote-exec" {
    inline = [
      "mysql -uroot -p${var.sql_password} -Bse \"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${var.sql_password}';\"",
      "mysql -uroot -p${var.sql_password} -Bse \"FLUSH PRIVILEGES;\"",
      "mysql -uroot -p${var.sql_password} -Bse \"UPDATE mysql.user SET host = '%' WHERE host = 'localhost' AND user = 'root';\"",
      "mysql -uroot -p${var.sql_password} -Bse \"UPDATE mysql.db SET host = '%' WHERE host = 'localhost' AND user = 'root';\"",
      "mysql -uroot -p${var.sql_password} -Bse \"FLUSH PRIVILEGES;\"",
      "mysql -uroot -p${var.sql_password} -Bse 'CREATE DATABASE ${var.name};'",
      "sudo mv /tmp/config.production.json tintt-gaubungbu",
      "cd tintt-gaubungbu",
      "pm2 start ecosystem.config.js",
      "sudo mysql -uroot -p${var.sql_password} ${var.name} < 'trtin.sql'",
      "service mysql restart",
      "sudo systemctl start nginx",
      "sudo systemctl restart nginx",
    ]
  }
}
