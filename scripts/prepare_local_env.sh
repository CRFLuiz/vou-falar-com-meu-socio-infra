#!/bin/bash
sudo chown -R 5050:5050 ./volumes/pgadmin
./scripts/create_dns_record.sh "vou-falar-com-meu-socio.lcdev.click"
docker compose up -d
docker compose logs -f --tail=100