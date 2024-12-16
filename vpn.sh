#!/bin/bash

# Load environment variables from the sibling .env file
ENV_FILE="$(dirname "$0")/.env" # Adjust path if necessary

if [ -f "$ENV_FILE" ]; then
  set -a  # Automatically export variables from the .env file
  . "$ENV_FILE"
  set +a  # Stop exporting variables
else
  echo "Error: .env file not found in the script's directory."
  exit 1
fi

# Check if sudo credentials are cached
sudo -n true 2>/dev/null
if [ $? -ne 0 ]; then
  # If credentials are not cached, provide the root password
  echo "$ROOT_PASSWORD" | sudo -S true
fi

# Run the VPN client with the password and echo 1 for further authentication
(
  echo "$VPN_PASSWORD"    # Send VPN password
  echo "1"                # Send "1" to confirm and continue
) | sudo DYLD_LIBRARY_PATH="$VPN_CLIENT_LIB" "$VPN_CLIENT" \
  -s "$VPN_SCRIPT" --cafile="$VPN_CAFILE" --protocol=gp \
  --user="$VPN_USER" --passwd-on-stdin "$VPN_HOST"
