#!/bin/bash

# Check if Domain argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 sub.example.com"
    exit 1
fi

DOMAIN=$1
WILDCARD="*.$DOMAIN"

echo "--- Requesting SSL Certificate ---"
echo "Domains: $DOMAIN, $WILDCARD"
echo ""

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo "Error: certbot is not installed."
    exit 1
fi

# Request certificate using DNS challenge
# We use certbot-dns-route53 which is pre-installed in the Docker image
echo "✅ Using certbot-dns-route53 plugin..."

# Execute Certbot
# -d $DOMAIN -d $WILDCARD : Request for both base domain and wildcard
# --dns-route53 : Use Route53 plugin
# --agree-tos : Agree to terms
# --no-eff-email : Don't share email
# --register-unsafely-without-email : For automation

certbot certonly \
    --dns-route53 \
    -d "$DOMAIN" \
    -d "$WILDCARD" \
    --agree-tos \
    --register-unsafely-without-email \
    --non-interactive \
    --server https://acme-v02.api.letsencrypt.org/directory

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SSL Certificate successfully generated!"
    echo "Locations:"
    echo " - Certificate: /etc/letsencrypt/live/$DOMAIN/fullchain.pem"
    echo " - Private Key: /etc/letsencrypt/live/$DOMAIN/privkey.pem"
    
    # Optional: Copy to nginx volume if needed
    # DEST_DIR="../volumes/nginx/certs"
    # mkdir -p $DEST_DIR
    # cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $DEST_DIR/server.crt
    # cp /etc/letsencrypt/live/$DOMAIN/privkey.pem $DEST_DIR/server.key
    # echo "Certificates copied to $DEST_DIR"
else
    echo ""
    echo "❌ Error: Failed to generate SSL certificate."
    exit 1
fi
