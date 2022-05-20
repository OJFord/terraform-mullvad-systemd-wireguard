terraform {
  required_providers {
    mullvad = {
      source  = "OJFord/mullvad"
      version = "0.2.1"
    }

    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.2.1+1"
    }
  }
}

provider "mullvad" {
  account_id = var.mullvad_account
}

provider "wireguard" {
}
