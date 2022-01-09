 terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_toke
  service_account_key_file = "/home/vagrant/devops-netology/yandex-cloud-terraform/key.json"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = yc.zone
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"
}
