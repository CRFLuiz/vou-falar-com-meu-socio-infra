#!/bin/bash
set -e

# Default domain from environment variable if argument not provided
DOMAIN=${1:-$DOMAIN_NAME}

if [ -z "$DOMAIN" ]; then
    echo "❌ Error: No domain provided. Pass as argument or set DOMAIN_NAME env var."
    exit 1
fi

echo "🚀 Starting Infrastructure Automation for: $DOMAIN"

# 1. Create/Update DNS Record
echo ""
echo "📡 Updating DNS Record..."
/scripts/create_dns_record.sh "$DOMAIN"

# 2. Generate/Renew SSL Certificate
echo ""
echo "🔒 Managing SSL Certificate..."
/scripts/create_ssl_cert.sh "$DOMAIN"

echo ""
echo "✅ All infrastructure tasks completed successfully!"
