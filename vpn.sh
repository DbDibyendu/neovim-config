
#!/bin/bash

# VPN credentials
VPN_PASSWORD="Performance@123456789"
VPN_USER="dibyendu.biswas"
VPN_HOST="secure.hotstar.com"
VPN_CAFILE="$HOME/vpnclient/cert.pem"
VPN_SCRIPT="$HOME/vpnclient/vpnc-script"
VPN_CLIENT="$HOME/vpnclient/openconnect"
VPN_CLIENT_LIB="$HOME/vpnclient"

# Run the VPN client with the password and echo 1 for further authentication
(
  echo "$VPN_PASSWORD"    # Send password
  echo "1"                # Send "1" to confirm and continue
) | sudo DYLD_LIBRARY_PATH="$VPN_CLIENT_LIB" "$VPN_CLIENT" \
  -s "$VPN_SCRIPT" --cafile="$VPN_CAFILE" --protocol=gp \
  --user="$VPN_USER" --passwd-on-stdin "$VPN_HOST"
