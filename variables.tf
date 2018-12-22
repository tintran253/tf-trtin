variable "name" {
  default = "trtin"
}

variable "sql_password" {}
variable "do_token" {}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_fingerprint" {}

variable "ports" {
  type = "map"

  default = {
    "elasticsearch" = 9200
  }
}

variable "slack_hook_url" {
  default = ""
}

data "template_file" "nginx" {
  template = "${file("./configs/nginx/default")}"
}

# data "template_file" "pw_cmd" {
#   template = "mysql -u$${var.name} -p$${sql_password} -Bse 'ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$${sql_password}';'"

#   vars {
#     sql_password = "${var.sql_password}"
#   }
# }

data "template_file" "prod_conf" {
  template = "${file("./configs/ghost/config.production.json")}"

  vars {
    sql_password = "${var.sql_password}"
    dbname       = "${var.name}"
  }
}
