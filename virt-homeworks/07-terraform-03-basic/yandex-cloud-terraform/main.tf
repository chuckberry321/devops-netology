 terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }


  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-bucket"
    region     = "ru-central1"
    key        = "main/terraform.tfstate"
    access_key = "RgX6o4liYaQz3hc8Mq7Q"
    secret_key = "6Ls2w3u4rAucDXi-WLpzltxW_GqGVRlKsyzzv_bU"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {

}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod = "t3.large"
  }
}

resource "yandex_compute_instance" "web" {

  boot_disk {
    initialize_params {
      image_id = "fd83klic6c8gfgi40urb"
    }
  }
  instance_type = local.web_instance_type_map[terraform.workspace]
}
