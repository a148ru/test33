###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "platform" {
  type = string
  default = "standard-v1"
}

variable vm_param {
  type = map(any)
  default = {
    web = ({
      cores = 2,
      memory = 2,
      core_fract = 100
    })
  }
}

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "serial_enable" {
  type = number
  default = 1
  description = "Serial port, default = enable (1)"
}

variable "user_name" {
  type = string
  default = "ubuntu"
}
variable "db_user_name" {
  type = string
}
variable "db_user_password" {
  type = string
}
