#!/bin/bash

# https://github.com/terraform-providers/terraform-provider-aws/issues/10104

set -euo pipefail

HOST=$(curl https://vstoken.actions.githubusercontent.com/.well-known/openid-configuration -s \
| jq -r '.jwks_uri | split("/")[2]')

echo | openssl s_client -servername $HOST -showcerts -connect $HOST:443 2> /dev/null \
| sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail +2 \
| openssl x509 -fingerprint -noout \
| tr '[:upper:]' '[:lower:]' \
| sed 's/://g; s/.*=\(.*\)/{"thumbprint": "\1"}/'
