`terraform-mullvad-systemd-wireguard` is a Terraform module that allows simple setup of a WireGuard client using Mullvad VPN, via systemd.

# Quickstart

The only required options are a Mullvad account number, and a city name; the latter because it's probably always desirable for at least one reason:
* proximity - low latency connection to your nearest city with Mullvad servers;
* geo-location - for streaming Linux distro ISOs unavailable in your region, or what have you;
* anti-geo-block - not desirable to be arbitrarily blocked from services in your own region because you happened to connect to a server outside it.

That requirement can be removed if there's a use-case and sensible alternative to adding _all_ Mullvad peers. (Perhaps the entire filter should be exposed.)

```hcl
module "mullvad" {
  source  = "OJFord/systemd-wireguard/mullvad"
  version = "0.1.0"

  mullvad_account = "0123 4567 8901 2345"
  city            = "London"
}
```

The `module.mullvad.files` output then provides key-value pairs of filenames & contents necessary for the configuration.
