# proxmox-tf-vms-modules

Terraform modules for VMs on Proxmox. This repository is public and holds
**no state, no backend, no provider block and no secret**.

The live configuration that calls these modules is private and lives in
`proxmox-tf-vms-config`.

## Layout

```
modules/
  base-vm/
    VERSION        the version of this module, X.Y.Z, one line
    versions.tf    required_version and required_providers
    variables.tf   inputs
    main.tf        the resource
    outputs.tf     outputs
    README.md
```

One folder is one module. One module has one version.

## Versions and tags

Each module carries its own `VERSION` file. When a change to a module reaches
`main`, the pipeline makes a tag from the folder name and that version:

| File | Content | Tag it makes |
| --- | --- | --- |
| `modules/base-vm/VERSION` | `1.0.0` | `base-vm/v1.0.0` |

Two modules never share a version number, because the tag carries the module
name. A pull request can change more than one module. Each one is checked and
tagged on its own.

**A tag never moves and never gets deleted.** A live VM pins a tag. If a tag
moved, a VM would change although nobody touched it. To change a module, raise
the version and make a new tag.

## How to use a module

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

The caller supplies the `provider "proxmox"` block, the `backend` block and the
credentials. The module supplies only the resource.

> The `?ref=` pin is the only thing that holds a module version. A
> `.terraform.lock.hcl` file locks providers, not modules.

## Pipelines

Runners are GitHub-hosted. This repository is public, so a self-hosted runner
is not available to it.

### Pull request into `main`

```
detect  ->  checks  ->  version-check
```

| Job | Does | Fails when |
| --- | --- | --- |
| `detect` | Lists the module folders that changed | Nothing under `modules/` changed, or a module folder was deleted |
| `checks` | `terraform fmt -check`, `init -backend=false`, `validate` for each changed module | Bad format, invalid HCL, a committed lock file, or a `backend`/`provider` block |
| `version-check` | Compares `VERSION` against `main` | No increase, a bad format, or a version that already has a tag |

### Push to `main`

```
detect  ->  checks  ->  tag
```

`tag` creates `<module>/v<VERSION>` and a GitHub Release for each changed
module. It is safe to run again: the same tag on the same commit is skipped,
and the same tag on a different commit is an error.

## Rules

1. A module never holds a `backend` block or a `provider` block. The caller
   holds both.
2. A module never commits `.terraform.lock.hcl`. The caller's lock file decides
   the provider version for a real plan.
3. `versions.tf` pins the provider version exactly. A `?ref=` pin must decide
   everything the module produces, and the provider is part of that.
4. Any change inside a module folder needs a version bump, a README change
   included. The tag is a picture of the whole folder.
