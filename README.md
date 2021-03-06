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

To use, you'll need to create a `terraform.tfvars` file and add your specifics. You can also copy the `terraform.tfvars.example` as a template.

``` toml
source_address_prefix = "1.2.3.0/24"
hab_origin = "jmassardo"
audit_pkg_name = "effortless-audit"
infra_pkg_name = "effortless-infra"
```

Next, you'll need to edit the `files\audit_user.toml` and `files\infra_user.toml` and specify the URL and token for your Automate instance. There are examples of these files as well.

Then, edit the `HabService.dll.{1...3}.config` files and specify the following settings on line 7:

``` bash
--event-stream-application effortless        # Name of your application
--event-stream-environment dev               # Environment name: dev, stg, prod, etc.
--event-stream-site uscentral                # Physical site or cloud region
--event-stream-url automate.example.com:4222 # Automate URL
--event-stream-token 123457890ABCDEFG=       # Automate Token
```

Then run `terraform apply`
