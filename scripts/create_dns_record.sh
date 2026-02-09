#!/bin/bash

# Check if DNS argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <dns_name>"
    echo "Example: $0 sub.example.com"
    exit 1
fi

FULL_DOMAIN=$1

# 1. Get Public IP
echo "--- Step 1: Detecting Public IP ---"
IP_ADDRESS=$(curl -s http://checkip.amazonaws.com)
if [ -z "$IP_ADDRESS" ]; then
    # Fallback to ifconfig.me
    IP_ADDRESS=$(curl -s ifconfig.me)
fi

if [ -z "$IP_ADDRESS" ]; then
    echo "Error: Could not determine public IP address."
    exit 1
fi
echo "Public IP: $IP_ADDRESS"
echo ""

# 2. Find Hosted Zone and Split Domain
echo "--- Step 2: Finding Hosted Zone in Route53 ---"
# List all hosted zones
HOSTED_ZONES_JSON=$(aws route53 list-hosted-zones --query 'HostedZones[*].{Id:Id, Name:Name}' --output json)

if [ $? -ne 0 ]; then
    echo "Error: Failed to list hosted zones. Please check your AWS CLI configuration."
    exit 1
fi

# Use Python to find the longest matching suffix (hosted zone)
read ZONE_ID ZONE_NAME <<< $(echo "$HOSTED_ZONES_JSON" | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)
    full_domain = '$FULL_DOMAIN'
    if not full_domain.endswith('.'):
        full_domain += '.'

    best_match_id = ''
    best_match_name = ''
    max_len = 0

    for zone in data:
        zone_name = zone['Name']
        if full_domain.endswith(zone_name):
            if len(zone_name) > max_len:
                max_len = len(zone_name)
                best_match_id = zone['Id']
                best_match_name = zone['Name']

    if best_match_id:
        print(f\"{best_match_id} {best_match_name}\")
except Exception as e:
    pass
")

if [ -z "$ZONE_ID" ]; then
    echo "Error: No matching hosted zone found for $FULL_DOMAIN in Route53."
    exit 1
fi

# Clean up Zone Name (remove trailing dot for display)
CLEAN_ZONE_NAME=${ZONE_NAME%.}
# Extract Subdomain
# If FULL_DOMAIN is "sub.example.com" and ZONE is "example.com", subdomain is "sub"
# If FULL_DOMAIN is "example.com" and ZONE is "example.com", subdomain is empty/root (@)

if [ "$FULL_DOMAIN" == "$CLEAN_ZONE_NAME" ]; then
    SUBDOMAIN="@"
else
    # Remove zone suffix
    SUBDOMAIN=${FULL_DOMAIN%.$CLEAN_ZONE_NAME}
fi

echo "Hosted Zone Found: $CLEAN_ZONE_NAME (ID: $ZONE_ID)"
echo "Subdomain Identified: $SUBDOMAIN"
echo ""

# 3. Create/Update Record
echo "--- Step 3: Updating Route53 Record ---"
CHANGE_BATCH=$(cat <<EOF
{
  "Comment": "Auto-created by script for $FULL_DOMAIN and wildcard",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$FULL_DOMAIN",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$IP_ADDRESS"
          }
        ]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "*.$FULL_DOMAIN",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$IP_ADDRESS"
          }
        ]
      }
    }
  ]
}
EOF
)

aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch "$CHANGE_BATCH"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! Records for $FULL_DOMAIN and *.$FULL_DOMAIN created/updated to point to $IP_ADDRESS"
else
    echo ""
    echo "❌ Error: Failed to update Route53 record."
    exit 1
fi
