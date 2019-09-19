# Windows Habitat Ring Example

## Intro

Greetings! This repository contains [Terraform](https://www.terraform.io) plans to provision a 3 node [Habitat](https://habitat.sh) supervisor ring using Windows Server 2019 on [Azure](https://www.azure.com).

## Notes

The plans perform the following steps on each server:

* Configures WinRM to allow remote configuration
* Installs Habitat
* Adds `--peer` options to the `HabService.dll.config` file
* Starts supervisor as a Windows Service

## Usage

To use, you'll need to create a `terraform.tfvars` file and add your subnet so your systems are exposed to the public Internet. You can also copy the `terraform.tfvars.example` as a template.

``` toml
source_address_prefix = "1.2.3.0/24"
```

Next, you'll need to edit the `files\audit_user.toml` and `files\infra_user.toml` and specify the URL and token for your Automate instance. There are examples of these files as well.

Edit the `files/Start-Habitat.ps1` script to change the habitat origin that get loaded when the machines boot up.

> Note: This assumes that the hab packages are named `effortless-infra` and `effortless-audit`. If you name your packages differently, you may need to make additional edits to this code; namely, the target path for the `user.toml` files

Then run `terraform apply`
