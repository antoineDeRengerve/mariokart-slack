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

## Env variables to be set

Get those information from Slack

  - Under "Basic information":
    - `SLACK_TOKEN`: App Credentials -> Verification token
    - `SLACK_CLIENT_ID`: App Credentials -> Client ID
    - `SLACK_CLIENT_SECRET`: App Credentials -> Client secret

  - Under "OAuth & Permissions":
    - `BOT_ACCESS_TOKEN`: OAuth Tokens for Your Workspace -> Bot User OAuth Token (it starts with `xoxb-`)

  - Use slack web to get this one:
    - `CHANNEL_ID`: the channel you want the bot to post to (you must `/invite @the_bot`)

Those ones depend from your server:
  - `LOGIN_REDIRECT_URL`: https://example.com/connect
  - `DATABASE_URL`: the URL of your PostgresSQL database
