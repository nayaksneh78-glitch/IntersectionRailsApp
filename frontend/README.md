# InterSection Vite guest guide

React + Vite frontend for the guest-facing Rails views. It lives next to the Rails app in `vite-guest-guide/` and reads the Rails JSON API.

## Run locally

1. Start Rails from `InterSection/` and prepare its database as described in `InterSection/README.md`.
2. From this directory, copy `.env.example` to `.env.local` if the Rails API is not at `http://localhost:3000`.
3. Run `npm install`, then `npm run dev`.
4. Open the Vite URL printed in the terminal. Vite proxies `/api` requests to Rails; set `RAILS_API_ORIGIN` to change the Rails origin.

## Production

Run `npm run build` and deploy the generated `dist/` directory. Serve the frontend and Rails API on the same origin, with a reverse proxy forwarding `/api/v1` to Rails and SPA routes falling back to `index.html`. The default API base is `/api/v1`; set `VITE_API_BASE_URL` at build time if the API is mounted elsewhere. The Rails API does not configure cross-origin browser access, so use a same-origin reverse proxy unless CORS is deliberately configured by the deployment.

## API access

GET requests are unauthenticated and include unpublished catalogue records. This is the selected behavior for this app. The frontend filters unpublished records and property assignments to mirror the Rails guest views, but the API itself does not hide them. Write requests remain protected by `INTERSECTION_API_TOKEN`; no secret is included in this frontend.

## Implementation summary

1. Matched the Rails guest flow and styling: property picker, single-property redirect, guide filters, place cards/details, and Google Maps links.
2. Split the UI into reusable React components and pages, with typed API records and a shared API/data layer.
3. Added paginated reads from the Rails API and client-side filtering that follows published property/neighbourhood/place rules.
4. Allowed unauthenticated API GET requests while preserving bearer-token protection for writes, and documented the unpublished-data exposure.
5. Added a local Vite-to-Rails proxy and documented the same-origin reverse-proxy requirement for production.
