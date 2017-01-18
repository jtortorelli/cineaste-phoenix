# Cineaste

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Data Seeding

Application data for development is inserted to Postgres step wise using seed scripts in `priv/repo/seeds/initial_data`. Scripts are run using `mix run <path>`. Scripts are dependent on order. These scripts are preserved here for reference and are not intended to be used for database setup on a local environment. Instead, use `db.sql` to restore a psql database with all available data, a la `psql cineaste_dev < db.sql`.

## Heroku

Application (such as it is at this time) is deployed at [`murmuring-mountain-10497.herokuapp.com`](https://murmuring-mountain-10497.herokuapp.com). Domain name [`godzillacineaste.net`](https://www.godzillacineaste.net) is currently resolving to the app. Security certificate has been procured via DNSimple.

## S3

All image resources, including posters, galleries, and person profile pictures, are hosted and retrieved from Amazon S3.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
