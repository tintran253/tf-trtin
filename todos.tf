resource "null_resource" "main-todo" {
  depends_on = ["digitalocean_droplet.main"]
  connection {
    host        = "${digitalocean_droplet.main.ipv4_address}"
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "5m"
  }

  # put elastic config file
  provisioner "file" {
    content     = "${data.template_file.todo_env.rendered}"
    destination = "/tmp/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/tintran253/tintt-todo.git",
      "mv /tmp/.env tintt-todo",
      "cd tintt-todo",
      "npm i",
      "npm i env-cmd -g",
      "npm i knex -g",
      "mysql -uroot -p${var.sql_password} -Bse 'CREATE DATABASE ${var.db_todo_name};'",
      "npm run migrate",
      "pm2 start server.js",
      "sudo systemctl start nginx",
      "sudo systemctl restart nginx",
    ]
  }
}
