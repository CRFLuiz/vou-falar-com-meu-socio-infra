# Authentication & User Management

## Sign Up Process
The sign-up process has been simplified to require minimal information.

### User Model
The following fields were removed to streamline the registration flow:
- `name`
- `professional_title`

**Current Required Fields:**
- `email`
- `password`

### API Endpoints
- **POST** `/auth/signup`: Accepts `email` and `password`.
- **POST** `/auth/login`: Not implemented yet.

When running behind Nginx with the default domains, the backend is exposed via the API subdomain (for example: `https://api.vou-falar-com-meu-socio.lcdev.click/auth/signup`).

## Frontend Implementation
The `Signup` page (`src/pages/Signup.tsx`) reflects these changes, presenting a simple form with only Email and Password fields.
