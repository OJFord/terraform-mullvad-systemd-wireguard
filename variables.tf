variable "mullvad_account" {
  description = "Your Mullvad account number."
  type        = string
}

variable "public_key" {
  description = "Your WireGuard public key. If unset, a keypair will be generated for you."
  type        = string
  default     = ""
}

variable "city" {
  description = "The city's Mullvad servers to add as peers."
  type        = string
}

variable "interface" {
  description = "The network interface name to use."
  type        = string
  default     = "wg0"
}

variable "dns" {
  description = "The DNSs to use."
  type        = list(string)
  default     = []
}

variable "fw_mark" {
  description = "Arbitrary firewall mark; set if necessary to avoid conflict."
  type        = number
  default     = 51820
}

variable "route_table" {
  description = "Arbitrary route table number; set if necessary to avoid conflict."
  type        = number
  default     = 51820
}
