# InterSection

InterSection is a Rails neighbourhood guide for a property’s guest iPad. Guests choose a property, filter its recommendations by category, tag or neighbourhood, and open each place in Google Maps. Operators maintain the catalogue in Active Admin.

## Run locally

Use Ruby 3.3 or 3.4 with Bundler. On Windows, install RubyInstaller **with Devkit** so Bundler can build native gems.

```sh
bundle install
ruby bin/rails db:prepare
ruby bin/rails server
```

Open http://localhost:3000 for the guest guide and http://localhost:3000/admin for Active Admin. Bookmark `/properties/<id>` on an iPad assigned to one property. A single property automatically opens from the home page.

To preview the guide with optional demo data, set `DEMO_DATA=1` and run `ruby bin/rails db:seed`. The production catalogue starts empty until operators add records or an API client imports them.

To create an operator, set `ADMIN_EMAIL` and `ADMIN_PASSWORD` in the shell environment and run `ruby bin/rails intersection:create_admin`. There is no default account. In PowerShell, set variables using `$env:ADMIN_EMAIL = "operator@example.com"`. Remove the password environment variable once the account is created.

## Configure a database

Development defaults to SQLite. Set `DATABASE_URL` to connect to an existing PostgreSQL or SQLite database. The migrations expect the application table names to be available. If the database already contains matching tables or similar data, compare its schema and reconcile migration history against a copy before running `db:migrate` on it. Test uses its own database by default and can be configured via `TEST_DATABASE_URL`.

For production, set `DATABASE_URL`, `SECRET_KEY_BASE`, and `INTERSECTION_API_TOKEN` through the deployment environment. Serve the application over HTTPS. Run `ruby bin/rails db:migrate` and `ruby bin/rails assets:precompile` before starting the server.

## Publish a guide

1. Create the property, tags and categories.
2. Create a neighbourhood and assign a tag.
3. Under **Property assignments**, connect the neighbourhood to the property.
4. Create city gems with a category, tag, neighbourhood, and a street address or other searchable location. Optionally supply a public HTTPS image URL.
5. Publish the city gem, the neighbourhood, and the assignment. To hide a neighbourhood for one property only, unpublish that assignment.

A neighbourhood can be assigned to multiple properties. A gem belongs to one neighbourhood, one category and one tag. The neighbourhood has its own tag. Each published gem appears for all published assignments of its published neighbourhood. Reassign existing references before deleting a tag or category. Deleting a neighbourhood deletes its assignments and gems.

## JSON API

Every endpoint returns JSON. GET requests are public and return all records, including unpublished records. POST, PATCH, PUT, and DELETE requests require `Authorization: Bearer <INTERSECTION_API_TOKEN>`. For imports, create tags, categories, and properties first. Use their returned IDs to create neighbourhoods, property assignments and city gems. Save each returned ID to update the same record via PATCH if you re-run an import. Do not expose this API publicly if unpublished catalogue data must remain private.

| Collection under `/api/v1` | Request envelope | Writable fields |
| --- | --- | --- |
| `tags` | `tag` | `title`, `hashtag`, `description` |
| `categories` | `category` | `title`, `description` |
| `properties` | `property` | `title`, `description`, `address` |
| `neighbourhoods` | `neighbourhood` | `title`, `description`, `pin` (latitude, longitude), `tag_id`, `published` |
| `property_neighbourhoods` | `property_neighbourhood` | `property_id`, `neighbourhood_id`, `published` |
| `city_gems` | `city_gem` | `title`, `short_desc`, `long_desc`, `image`, `location`, `tag_id`, `category_id`, `neighbourhood_id`, `published` |

Use GET to list or show, POST to create, PATCH or PUT to update, and DELETE to remove. Lists accept `page` and `per_page` (default 50, maximum 100). Successful reads and writes return a `data` envelope. Creation responds with 201 and a Location header. Deletion returns 204. Validation errors return 422 with an `errors` object.

Example in a POSIX shell with the token set in the environment:

```sh
curl -X POST http://localhost:3000/api/v1/tags \
  -H "Authorization: Bearer $INTERSECTION_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tag":{"title":"Outdoor","hashtag":"outdoor"}}'
```

## Test

```sh
bundle exec rspec
```

The suite covers model validations and deletion rules, guest publication boundaries and filters, routing, authenticated JSON CRUD, and Active Admin sign-in and resource rendering.
