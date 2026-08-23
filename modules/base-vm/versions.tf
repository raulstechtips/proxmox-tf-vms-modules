# The provider version is pinned exactly, not with a range.
#
# A caller pins this module with ?ref=base-vm/vX.Y.Z. That pin must decide
# everything the module produces, and the provider version is part of that.
# A range would let a new provider release change an existing VM without a
# module bump. To move the provider, bump this file and the VERSION file.
terraform {
  required_version = ">= 1.11"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}
