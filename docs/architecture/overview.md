# Architecture Overview

This project uses a containerized microservices architecture managed by Docker Compose.

## Services

| Service | Description | Port |
|---------|-------------|------|
| **nginx** | Reverse Proxy & SSL Termination. Entry point for all traffic. | 80 (HTTP), 443 (HTTPS) |
| **frontend** | React/Vite application. | 3000 (Internal) |
| **backend** | Node.js/Express API. | 3000 (Internal) |
| **backend-migration** | Ephemeral container for running DB migrations on startup. | - |
| **postgres** | PostgreSQL Database. | 5432 |
| **pgadmin** | Database management interface. | 8080 |
| **litellm** | OpenAI-compatible LLM proxy used by internal services. | 4000 (Internal) |
| **infra-tools** | Utility container for tasks like Certbot (SSL) and DNS updates. | - |

## Network Flow

1.  **External Request** -> **Nginx** (Port 80/443)
2.  **Nginx** routes based on domain:
    *   `vou-falar-com-meu-socio.lcdev.click` -> **frontend**
    *   `api.vou-falar-com-meu-socio.lcdev.click` -> **backend**
3.  **Backend** connects to **Postgres** (Port 5432).
4.  Internal services can call **LiteLLM** directly over the Docker network (`http://litellm:4000`).

## Volumes & Persistence

*   `./volumes/postgres`: Database data persistence.
*   `./volumes/pgadmin`: PgAdmin configuration persistence.
*   `./volumes/litellm`: LiteLLM proxy configuration.
*   `./volumes/nginx/certs`: SSL certificates (shared between host/infra-tools and Nginx).
*   `./volumes/nginx/nginx.conf`: Nginx configuration file.
