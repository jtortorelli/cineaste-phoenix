# Cineaste

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Data Seeding

Application data is inserted to Postgres step wise using seed scripts in `priv/repo/seeds/initial_data`. Scripts are run using `mix run <path>`. Scripts are dependent on order. A master script for inserting data has been considered, but given the amount of data that will potentially be included in this application, the inclusion of a SQL dump file is far more likely as a means of standing up the application for development.

## Heroku

Application (such as it is at this time) is deployed at [`murmuring-mountain-10497.herokuapp.com`](https://murmuring-mountain-10497.herokuapp.com). Domain name [`godzillacineaste.net`](https://www.godzillacineaste.net) is currently resolving to the app, although no SSL certificate has been provisioned yet and the site will trigger a security warning on the first visit.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
