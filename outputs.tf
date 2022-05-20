output "files" {
  description = "The systemd-networkd files to configure."
  value = {
    "/etc/systemd/network/10-${var.interface}.netdev"           = replace(local.systemd_netdev, "/(?m:^[[:space:]]+(.*))/", "$1")
    "/etc/systemd/network/10-${var.interface}.network"          = replace(local.systemd_network, "/(?m:^[[:space:]]+(.*))/", "$1")
    "/etc/systemd/networkd.conf.d/${var.interface}-tunnel.conf" = replace(local.networkd_conf, "/(?m:^[[:space:]]+(.*))/", "$1")
    "/etc/wireguard/${var.interface}.key"                       = var.public_key != "" ? "" : wireguard_asymmetric_key.client[0].private_key
  }
}
