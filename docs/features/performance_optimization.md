# Performance Optimization

## Overview
This document describes the changes made to improve the application's performance, specifically addressing high Largest Contentful Paint (LCP) and inefficient resource loading.

## Changes Implemented

### 1. Production Build in Docker
- **Problem (Production):** Running the frontend in development mode (`yarn dev`) in production causes the browser to download many unoptimized module files, which can severely degrade performance (LCP and overall load time).
- **Solution (Production):** Use `yarn build && yarn preview` so the container serves bundled and optimized assets.
- **Impact:** 
    - The application now serves optimized, minified, and bundled assets.
    - Significantly reduced the number of network requests.
    - Improved load times and LCP score.

## Technical Details
- **Production Docker Compose Command:** `/bin/sh -c "yarn install && yarn build && yarn preview"`
- **Development Docker Compose Command:** `/bin/sh -c "yarn install && yarn dev"`
- **Rationale:** `yarn dev` is faster and better for development workflows (HMR), while `build + preview` is the recommended option when deploying to production.
