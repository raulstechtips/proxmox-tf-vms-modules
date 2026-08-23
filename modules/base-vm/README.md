# base-vm

Makes one Proxmox VM as a full clone of a template, set up by cloud-init.

## Example

```hcl
module "vm" {
  source = "git::https://github.com/raulstechtips/proxmox-tf-vms-modules.git//modules/base-vm?ref=base-vm/v1.0.0"

  env         = "dev"
  name        = "ansible-builder"
  agent       = "1"
  target_node = var.target_node
  clone       = "dev-base-template-1"
  cores       = 1
  memory      = 2048
  size        = "20G"
  ipconfig0   = var.ipconfig0
  ciuser      = var.ciuser
}
```

The VM name is built as `<env>-<name>-<agent>`. The example above makes
`dev-ansible-builder-1`.

## Inputs

| Name | Type | Description |
| --- | --- | --- |
| `env` | `string` | Environment prefix in the VM name. Example: `dev`. |
| `name` | `string` | Role part of the VM name. Example: `ansible-builder`. |
| `agent` | `string` | Instance number, the last part of the VM name. |
| `target_node` | `string` | Proxmox node that holds the VM. |
| `clone` | `string` | Name of the Proxmox template to clone. |
| `cores` | `number` | Number of CPU cores. |
| `memory` | `number` | Memory in MiB. Example: `2048`. |
| `size` | `string` | Size of the virtio0 disk, with a unit. Example: `20G`. |
| `ipconfig0` | `string` | Cloud-init network line. Example: `ip=10.0.0.10/24,gw=10.0.0.1`. |
| `ciuser` | `string` | Default cloud-init user. |

Every input is required. There are no defaults.

> `agent` is the instance number. It is not the QEMU guest agent setting. The
> guest agent is on and is not configurable in this version.

## Outputs

| Name | Description |
| --- | --- |
| `id` | Terraform resource ID. |
| `vmid` | Proxmox numeric VM ID. |
| `name` | Full VM name. |
| `default_ipv4_address` | First IPv4 address the guest agent reports. Empty until the agent answers. |
| `ssh_host` | Host that Proxmox reports for SSH. |
| `ssh_port` | Port that Proxmox reports for SSH. |

## Fixed values

These are set in the resource and cannot be changed by an input in this
version. They become inputs in a later version, with these as the defaults.

| Setting | Value |
| --- | --- |
| Disk storage | `local-lvm` |
| Cloud-init drive | `ide3` on `local-lvm` |
| Boot disk | `virtio0` |
| SCSI controller | `virtio-scsi-pci` |
| Network bridge | `vmbr0`, model `virtio` |
| CPU | `host`, 1 socket |
| Start on boot | `true` |
| Guest agent | on |

## What the caller must supply

The module holds no `provider` block and no `backend` block.

```hcl
terraform {
  required_version = ">= 1.11"
  backend "s3" {}
}

provider "proxmox" {
  # PM_API_URL, PM_API_TOKEN_ID and PM_API_TOKEN_SECRET come from the environment
  pm_tls_insecure = true
}
```

## Provider

Pinned exactly to `telmate/proxmox` `3.0.1-rc3`. To move the provider, raise
`VERSION` and make a new tag.
