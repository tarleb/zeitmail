#!/bin/bash
# Create a config file containing a new, random DES key.
set -e

des_config_file="$1"

# Generate a new key containing exactly 24 alpha-numerical chars.
new_key="$(tr -cd "[:alnum:]" < /dev/urandom 2> /dev/null | head -c 24)"

# The config is a line of PHP code.
printf "\$config['des_key'] = '%s';\n" "$new_key" > "$des_config_file"
