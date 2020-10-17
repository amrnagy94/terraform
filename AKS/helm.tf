
provider "helm" {
  kubernetes {
    config_path = "${file("c:/users/lenovo/.kube/config")}"
  }
}

resource "helm_release" "mydatabase" {
  name  = "mydatabase"
  chart = "stable/mariadb"

  set {
    name  = "db.name"
    value = "foo"
  }

  set {
    name  = "db.user"
    value = "nagy"
  }
      set {
    name  = "db.password"
    value = "Temp1234"
  }
}