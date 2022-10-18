# mariokart-slack

## Setup App

Requires Docker

1. Create the Docker image with `docker-compose build app`
1. Copy `.env.example` to `.env` and set `SLACK_TOKEN` to the right value
1. Start the server with `docker-compose up`
1. Initiate the database
   1. Open a console and connect to your Docker instance : 
     `docker-compose exec app bash`
   1. Create the database structure and execute migrations :
     ```shell
     RACK_ENV=production rake db:drop
     RACK_ENV=production rake db:create
     RACK_ENV=production rake db:migrate
     ```
1. You're all set! Your app is now up and running

SLACK_TOKEN: App Credentials -> Verification token
