locals {
    vms_ssh_root_key = {
        serial_port = ({
            stat = var.serial_enable
        }),
        ssh = ({
            key = "${var.user_name}:${var.vms_ssh_root_key}"
        })
        }
}
