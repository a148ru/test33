resource "yandex_vpc_network" "from-terraform-network" {
  name = "from-terraform-network"
}

resource "yandex_vpc_subnet" "from-terraform-subnet" {
  name           = "from-terraform-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.from-terraform-network.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

data "yandex_compute_image" "ubuntu" {
  #family = var.image.web
  image_id = "fd8j7kdqnfe379a4rtb0"
}

resource "yandex_compute_instance" "from-terraform-vm" {
  name        = "from-terraform-vm"
  platform_id = var.platform
  resources {
    cores         = var.vm_param.web.cores
    memory        = var.vm_param.web.memory
    core_fraction = var.vm_param.web.core_fract
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.from-terraform-subnet.id
    nat       = true
  }

  metadata = {
    serial-port-enable = local.vms_ssh_root_key.serial_port.stat
    ssh-keys           = local.vms_ssh_root_key.ssh.key
  }

}

resource "yandex_mdb_postgresql_cluster" "test-vm" {
  name                = "test-vm"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.from-terraform-network.id
  deletion_protection = false

  config {
    version = "17"
    resources {
      resource_preset_id = "s1.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
    pooler_config {
      pool_discard = false
      pooling_mode = "SESSION"
    }
  }

  host {
    zone             = var.default_zone
    name             = "test-vm"
    subnet_id        = yandex_vpc_subnet.from-terraform-subnet.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_postgresql_database" "db1" {
  cluster_id = yandex_mdb_postgresql_cluster.test-vm.id
  name       = "db1"
  owner      = yandex_mdb_postgresql_user.user1.name
  depends_on = [
    yandex_mdb_postgresql_user.user1
  ]
}

resource "yandex_mdb_postgresql_user" "user1" {
  cluster_id = yandex_mdb_postgresql_cluster.test-vm.id
  name       = var.db_user_name
  password   = var.db_user_password
}

