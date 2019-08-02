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

To use, you'll need to create a `terraform.tfvars` file and add your subnet so your systems are exposed to the public Internet.

``` toml
source_address_prefix = "1.2.3.0/24"
```

You'll also need to edit the `audit_user.toml` and `infra_user.toml` and specify the URL and token for your Automate instance.

Edit the `files/Start-Habitat.ps1` script to change the hab packages that get loaded when the machines boot up.

Then run `terraform apply`
