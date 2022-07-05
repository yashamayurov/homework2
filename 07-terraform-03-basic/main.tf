terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
   backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netobucket1"
    region     = "ru-central1"
    key        = "global/s3/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = "b1gujivevjlp7t5e57pg"
  folder_id = "b1ggm5c63bsod5kmc3cg"
  zone      = "ru-central1-a"
}

resource "yandex_storage_bucket" "netobucket1" {
  access_key = ""
  secret_key = ""
  bucket = "netobucket1"
}

resource "yandex_compute_image" "foo-image" {
  name       = "myimage"
  source_image = "fd80le4b8gt2u33lvubr"
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

locals {
  instance = {
  stage = 1
  prod = 2
  }
}

resource "yandex_compute_instance" "vm1" {
  name = "mymachineforhomework"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.foo-image.id}"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

count = local.instance[terraform.workspace]
}

locals {
  id = toset([
    "1",
    "2",
  ])
}

resource "yandex_compute_instance" "vm2" {
  name = "mymachine2forhomework"
  for_each = local.id
  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.foo-image.id}"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
 lifecycle {
    create_before_destroy = true
  }
}


