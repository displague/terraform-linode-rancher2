variable "token" {}

provider "linode" {
  token = "${var.token}"
}

resource "linode_instance" "rancher2" {
  label  = "rancher2-bootstrap"
  region = "us-east"
  type   = "g6-standard-2"
  image  = "linode/ubuntu18.04"

  provisioner "remote-exec" {
    inline = "apt-get update; apt-get install docker; docker run rancher/rancher:master -p 80:80 -p 443:443"
  }
}

provider "rancher2" {
  api_url = "https://..."
  access_key = "var.rancher2_access_key"
  secret_key = "var.rancher2_secret_key"
}

resource "rancher2_cluster" "linode-cluster" {
  name        = "foo-custom"
  description = "Foo rancher2 custom cluster"
  kind        = "rke"

  rke_config {
    network {
      plugin = "canal"
    }
  }
}

resource "rancher2_node_driver" "foo" {
  active            = true
  builtin           = false
  checksum          = "dcde63151613b7ea1f4fc3fb7b805a3bb90836f2935592d4dc22d6b40f09b7e1"
  description       = "Linode driver"
  name              = "linode"
  url               = "https://github.com/linode/docker-machine-driver-linode/releases/download/v0.1.5/docker-machine-driver-linode_linux-amd64.zip"
  ui_url            = "https://github.com/displague/ui-driver-linode/releases/download/v0.1.0/component.js"
  whitelist_domains = ["*.github.com"]
}

//resource "rancher2_node_template" "linode" {
//  name = "linode"
//  description = "foo3 test"
//  linode_config {
//    authorizedUsers = ""
//    token = "XXXXXXXXXXXX"
//  }
//}


//resource "rancher2_node_pool" "linode-pool" {
//  cluster_id =  "${rancher2_cluster.linode-cluster.id}"
//  name = "foo"
//  hostname_prefix =  "linode-cluster-0"
//  node_template_id = "${rancher2_node_template.linode.id}"
//  quantity = 3
//  control_plane = true
//  etcd = true
//  worker = true
//}

