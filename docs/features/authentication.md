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
- **POST** `/api/auth/signup`: Accepts `email` and `password`.
- **POST** `/api/auth/login`: Accepts `email` and `password`.

## Frontend Implementation
The `Signup` page (`src/pages/Signup.tsx`) reflects these changes, presenting a simple form with only Email and Password fields.
