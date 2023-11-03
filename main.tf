terraform {
  required_version = "1.4.7"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

######
### Create Load Balancer
######
resource "yandex_lb_network_load_balancer" "load-balancer" {
  name = "terraform-load-balancer"

  listener {
    name        = "my-listener-load-balancer"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.load-balancer-target-group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80

      }
    }
  }
}

resource "yandex_lb_target_group" "load-balancer-target-group" {
  name = "my-load-balancer-target-group"
  target {
    subnet_id = yandex_vpc_subnet.local-network-1.id
    address   = module.vm_instance_1.internal_ip_address_vm
  }
  target {
    subnet_id = yandex_vpc_subnet.local-network-2.id
    address   = module.vm_instance_2.internal_ip_address_vm
  }
}


######  
### Создаем сеть terraform-network
######
resource "yandex_vpc_network" "terraform-network" {
  name        = "terraform-network-prod"
  description = "For terraform project"
}


######
### Создаем две подсети local-network-1 и local-network-2
######
resource "yandex_vpc_subnet" "local-network-1" {
  name           = "local-network-1"
  zone           = "ru-central1-a"
  description    = "local-network-prod"
  network_id     = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["10.16.10.0/24"]
}

resource "yandex_vpc_subnet" "local-network-2" {
  name           = "local-network-2"
  zone           = "ru-central1-b"
  description    = "local-network-test"
  network_id     = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["10.16.20.0/24"]
}


######
### Создание виртуальных машин 
######
module "vm_instance_1" {
  source                = "./modules/"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.local-network-1.id
  instans_zone_id       = "ru-central1-a"
}
module "vm_instance_2" {
  source                = "./modules/"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.local-network-2.id
  instans_zone_id       = "ru-central1-b"
}




