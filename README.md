# InterSection

InterSection is a neighbourhood guide for guests staying at Section L properties in Tokyo. Guests choose a property, filter nearby recommendations, and open places in Google Maps.

## Section L sample catalog

### Properties

| Property | Neighbourhoods in its guide |
| --- | --- |
| Section L Hatchobori | Hatchobori |
| Section L Ginza East | Ginza, Hatchobori |
| Section L Residence Ginza | Ginza |

The catalog covers Hatchobori, Ginza, and Tsukiji. The three sample properties link to Hatchobori and Ginza. Tsukiji has its own recommendations in the catalog and can be assigned to a property in Rails.

### City gems

| Place | Category | Neighbourhoods | What guests will find |
| --- | --- | --- | --- |
| Turret Coffee | Food & Drink | Ginza, Hatchobori, Tsukiji | A small café with matcha and seasonal lattes. |
| Maru | Food & Drink | Ginza, Hatchobori, Tsukiji | Wine and small plates. |
| Nihombashi Sando | Food & Drink | Ginza, Hatchobori, Tsukiji | A modern izakaya serving Japanese classics. |
| Postalco | Shopping | Ginza | A Tokyo design studio and shop. |
| FEELSEEN | Shopping | Ginza | A shop featuring artisan goods. |
| Ginza Six Rooftop | Culture | Ginza | A rooftop retreat overlooking Ginza. |
| Cafe Ajito .N | Food & Drink | Hatchobori | A café with a sheep figure at the entrance. |
| Teppozu Inari Shrine | Culture | Hatchobori | A residential shrine with a small Mount Fuji replica. |
| Senmaiya | Food & Drink | Hatchobori | A shop serving onigiri with a range of fillings. |
| Shutoku Ganso | Food & Drink | Tsukiji | An eight-seat omakase sushi counter. |
| Ichifuji | Shopping | Tsukiji | A shop for kitchen tools and tableware. |
| Kunisuke Coffee | Food & Drink | Tsukiji | A plant-covered café with rotating pastries. |

The JSON fixture includes property addresses, neighbourhood map pins, place descriptions, tags, Google Maps links, and image URLs where available. It records inferred values separately when source fields are missing. [Original Section L sample data](https://section-l.notion.site/Sample-Data-3f012e50f75980628c68ce5a3bd10579) · [Repository fixture](./InterSection/section-l-sample-data.json)

## What we implemented

- **Rails (`InterSection/`)** stores properties, neighbourhoods, property assignments, categories, tags, and city gems. It provides the original server-rendered guest guide, Active Admin for managing the catalog, and a paginated JSON API. API reads are public and include unpublished records. Write requests require a bearer token. [Rails setup and API documentation](./InterSection/README.md)
- **React (`frontend/`)** recreates the guest guide in TypeScript with Vite. It reads the Rails API and applies publication rules in the UI. Guests can pick or switch properties, filter by category, tag, or neighbourhood, and open place details and Google Maps links. Vite proxies API requests to Rails during development. [Frontend setup and deployment](./frontend/README.md)

## Run locally

Start Rails from the repository root.

```sh
cd InterSection
bundle install
ruby bin/rails db:prepare
ruby bin/rails server
```

In a second terminal, start the frontend from the repository root with Node.js 22.12 or later.

```sh
cd frontend
npm ci
npm run dev
```

Open the URL Vite prints. The frontend connects to Rails at `http://localhost:3000` by default. Add catalog records through Active Admin or the Rails API to populate the guide. The Section L JSON fixture is a reference dataset. The optional Rails demo seed loads a separate catalog.
