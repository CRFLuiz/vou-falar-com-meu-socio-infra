# SSL & Reverse Proxy

## Nginx Configuration
The Nginx service acts as the main entry point and handles:
1.  **SSL Termination:** Decrypts HTTPS traffic using Let's Encrypt certificates.
2.  **HTTP Redirect:** Automatically redirects port 80 traffic to 443.
3.  **Reverse Proxy:** Routes traffic to internal containers based on subdomains.
    *   `vou-falar-com-meu-socio.lcdev.click` -> `frontend:3000`
    *   `api.vou-falar-com-meu-socio.lcdev.click` -> `backend:3000`
    *   `db-admin.vou-falar-com-meu-socio.lcdev.click` -> `pgadmin:80`
    *   `litellm.vou-falar-com-meu-socio.lcdev.click` -> `litellm:4000`

## Health Checks
Services are configured with Docker healthchecks to ensure reliability and correct startup order.

*   **Backend:** Exposes `GET /health` (returns 200 OK).
*   **Frontend:** Exposes `GET /health.json` (static file returning 200 OK).
*   **Dependencies:**
    *   `nginx` waits for `frontend` and `backend` to be healthy.
    *   `frontend` waits for `backend` to be healthy.
    *   `backend` waits for `postgres` (healthy) and `backend-migration` (completed).
