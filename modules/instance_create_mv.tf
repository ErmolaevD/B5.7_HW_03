###### Для обхлода блокировки в РФ
terraform {
  required_version = "1.4.7"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}


#search images 
data "yandex_compute_image" "used_images" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "vm" {
  name = "terraform-${var.instance_family_image}"
  zone = var.instans_zone_id

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  #Used images 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.used_images.id
      size     = 5
    }
  }
  #Used network and subnet
  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  #Путь до ssh ключв и пользователь для коннекта ubuntu
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
