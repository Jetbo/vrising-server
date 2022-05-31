# V Rising Dedicated Server on AWS Fargate

This repo will run a V Rising Dedicated Server as a container on AWS Fargate Spot servers. V Rising runs in a Linux container via [wine](https://www.winehq.org/).

The Dockerfile has does *NOT* have anything specific to AWS, so it should be portable to other cloud services or it can run on your local machine.

AWS is pay as you go, so keep in mind how many resources you assign to your task in Fargate, how long you keep your logs, how many save files you keep, etc. This setup uses [AWS Fargate Spot pricing](https://aws.amazon.com/fargate/pricing/), so costs are reduced, but don't let the costs surpise you!.

## Known Limitations

Apparently V Rising on Debian Bullseye and AWS Fargate don't play well together, so the Dockerfile must be run on Ubuntu (I am using Kinetic). If someone can figure out how to make it work on plain Debian, I would highly appreciate it. Ubuntu image size is much larger than plain Debian and is much slower to build.

V Rising currently does not have a manual save option for dedicated servers, so expect progression loss if the server exits unexpectedly. This can be mitigated somewhat by editing `AutoSaveInterval` in `server_settings/ServerHostSettings.json` to a lower value.

V Rising multiplayer Direct Connect does not support DNS resolution. This means you can't assign a domain name to your server like `vrising.mydomain.com:27015`. Instead you have to use an IPv4 address. ECS Fargate uses ephermal IP addresses, which means if the task restarts or gets replaced, the IP address needed to connect may change.

GitHub Actions is not yet implemented for Dockerfile image deploys, so you must build and push your image manually to AWS ECR.

## AWS Infrastructure Diagram

TODO

## Setup Requirements

- [An AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
  - [AWS Client](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - [AWS Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) 
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  - Setup with an AWS Provider in the AWS region you want
  - Setup with a root module to configure your AWS options.
- [Docker](https://docs.docker.com/get-docker/)
- [V Rising Server and Game Settings](https://github.com/StunlockStudios/vrising-dedicated-server-instructions). Example settings are provided in `server_settings/defaults/`. Put your customized settings in the folder `server_settings/`.

```terraform
# Example of AWS Provider @ terraform/providers.tf:

terraform {
  required_version = ">= 1.1.7"

  backend "s3" {
    bucket  = "dedicated-server-terraform"
    key     = "vrising/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    profile = "personal"
  }
}

provider "aws" {
  region = "us-west-2"
  profile = "personal"
}
```

```terraform
# Example of root module @ terraform/main.tf:

module "vrising" {
  source = "./vrising-dedicated-server"

  openid_github_repo = "repo:{YOUR_GITHUB_ORG_OR_USERNAME}/vrising-server:*"

  server_name = "My Multiplayer World"
  
  cpu = 2048
  cpu_reservation = 1920
  memory = 8192
  memory_reservation = 7936

  log_retention_in_days = 30
}
```

## How to Run

1. `cd terraform`
2. `terraform init`
3. `terraform apply -auto-approve`. `-auto-approve` is optional of course.
4. TODO: GitHub Actions


## Future Features

GitHub Actions to build and push to AWS ECR.

Domain name resolution (when V Rising supports it)


