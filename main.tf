resource "wireguard_asymmetric_key" "client" {
  count = var.public_key != "" ? 0 : 1
}

locals {
  public_key = var.public_key != "" ? var.public_key : wireguard_asymmetric_key.client[0].public_key
}

resource "mullvad_wireguard" "client" {
  public_key = local.public_key
}

data "mullvad_relay" "server" {
  filter {
    city_name = var.city
    type      = "wireguard"
  }
}

locals {
  servers = data.mullvad_relay.server.relays

  route_table_name = "${var.interface}-tunnel"

  systemd_netdev = <<EOC
      [NetDev]
      Name=${var.interface}
      Kind=wireguard
      Description=WireGuard

      [WireGuard]
      PrivateKeyFile=/etc/wireguard/${var.interface}.key
      RouteTable=${local.route_table_name}
      FirewallMark=${var.fw_mark}

    %{for peer_idx, peer in local.servers}
      [WireGuardPeer]
      PublicKey=${peer.public_key}
      Endpoint=${peer.hostname}:51820
      AllowedIPs=0.0.0.0/0,::/0
    %{endfor}
  EOC

  systemd_network = <<EOC
      [Match]
      Name=${var.interface}

      [Network]
      Address=${mullvad_wireguard.client.ipv4_address}
      Address=${mullvad_wireguard.client.ipv6_address}
    %{for dns in var.dns}
      DNS=${dns}
    %{endfor}

      [Route]
      Gateway=0.0.0.0
      Table=${local.route_table_name}

      [Route]
      Gateway=::
      Table=${local.route_table_name}

      [RoutingPolicyRule]
      Family=both
      InvertRule=true
      FirewallMark=${var.fw_mark}
      Table=${var.interface}-tunnel

      [RoutingPolicyRule]
      Family=both
      SuppressPrefixLength=0
      Table=main
  EOC

  networkd_conf = <<EOC
    [Network]
    RouteTable=${local.route_table_name}:${var.route_table}
  EOC
}
