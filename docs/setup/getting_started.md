# Getting Started

## Prerequisites
*   Docker & Docker Compose
*   Git

## Environment Setup
1.  Navigate to `vou-falar-com-meu-socio-infra`.
2.  Optional: create a local `.env` file if you plan to use the `infra-tools` profile (SSL/DNS automation). This repository can be started without a `.env` file for day-to-day development.
3.  If you created a `.env`, ensure the `DOMAIN_NAME` variable is set correctly (default: `vou-falar-com-meu-socio.lcdev.click`).

## Running the Application
1.  Start the infrastructure:
    ```bash
    docker compose up -d
    ```
    This will start Nginx, Frontend, Backend, Postgres, and PgAdmin.
    *   **Frontend:** `https://vou-falar-com-meu-socio.lcdev.click`
    *   **Backend API:** `https://api.vou-falar-com-meu-socio.lcdev.click`
    *   **PgAdmin:** `http://localhost:8080`
    > **Note:** If PgAdmin fails to start with "Permission denied" errors, fix volume permissions:
    > ```bash
    > sudo chown -R 5050:5050 ./volumes/pgadmin
    > docker compose restart pgadmin
    > ```

## Generating SSL Certificates
The project includes a helper tool to generate Let's Encrypt certificates automatically using DNS-01 challenge (via Route53).

1.  Run the `infra-tools` container:
    ```bash
    docker compose --profile tools up infra-tools
    ```
2.  This will:
    *   Update Route53 DNS records (if configured).
    *   Generate/Renew SSL certificates.
    *   Save certificates to `./volumes/nginx/certs`.

## Development Notes
*   **Hot Reload:** Frontend and Backend containers mount the source code volumes, so changes in `../vou-falar-com-meu-socio-frontend` or `../vou-falar-com-meu-socio-backend` are reflected immediately (HMR supported).
*   **Dev vs Production Commands:** During development, the containers should use `yarn dev` for faster iteration. For production deployments, prefer `yarn build && yarn preview` to serve optimized assets.
*   **Logs:** Use `docker compose logs -f [service_name]` to view logs.
