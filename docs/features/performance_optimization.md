# Performance Optimization

## Overview
This document describes the changes made to improve the application's performance, specifically addressing high Largest Contentful Paint (LCP) and inefficient resource loading.

## Changes Implemented

### 1. Production Build in Docker
- **Problem:** The application was running in development mode (`yarn dev`) in the production environment. This caused the browser to download hundreds of individual, unoptimized module files, leading to severe performance degradation.
- **Solution:** Switched the `command` in `docker-compose.yml` to use `yarn build && yarn preview`.
- **Impact:** 
    - The application now serves optimized, minified, and bundled assets.
    - Significantly reduced the number of network requests.
    - Improved load times and LCP score.

## Technical Details
- **Docker Compose Command:** `/bin/sh -c "yarn install && yarn build && yarn preview"`
- **Environment:** The frontend container now acts as a preview server for the built artifacts rather than a hot-reloading development server.
