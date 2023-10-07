# README
Vincetagram is a private image-based social network designed for me and my family to store and share images to people we know. The app is also sometimes known as "Postcard".

The app has very basic image sharing functionality - admin users can upload posts containing images and normal users can see these.

Auth happens by a magic email link, there are no passwords at all. Admin users are the only users who can invite someone, and then that person will receive an email to sign in. If they get logged out, they can generate another link again. The tokens are single use.

The emails are sent via Amazon SES. Credentials are included on the production box.

# Development
This is a rails app. You need to have Ruby and PSQL installed locally for it to work. Check the `.ruby-version` file for specific version information.

Although we run the production application in docker, I haven't set up the development environment to run in docker. Just get it working locally.

## Setup
- Check out `.env.example` for the variables you'll need in your environment
- `bin/bundle install` to install deps
- `bin/rake db:prepare` to create and migrate the database
- `bin/dev` to start the application on port 3000

# Production
This is currently deployed on my home server using docker.

## Docker
Environment variables are drawn from a .env file stored on the server and pulled into the docker container.

See the dockerfile for more information. We use `docker-compose` to orchestrate the app container and the associated services (postgres)

## Rails app user
The app runs as a user, `rails`, with an ID of 1003. Sometimes it has to interact with the filesystem on the host machine. If it needs to interact with more places on the host machine's filesystem, you will need to update the permissions on the host machine to reference the rails user.

If in doubt, check out the directories already referenced as volume mounts in the `docker-compose.yml` file, see their permissions, and copy that.

## Nginx
The port is exposed via docker, check the box for specific configuration. No port is exposed to the internet, instead everything funnels through an NGINX reverse proxy, which is exposed via a Cloudflare tunnel.

Nginx configuration is available at the [config repo](https://github.com/joshvince/vince-family-archive-config)

## Images and Videos
The rails server stores ActiveStorage blobs in a volume which is defined in the BLOB_STORAGE_ROOT environment variable. This needs to be present on the server and should not be wiped with each deploy. Make sure that this directory is gitignored otherwise you'll delete all the files when you deploy...

Images themselves are sync'd when they are saved from the blob directory to the main archive on the server, which is defined in the FILE_STORAGE_ROOT environment variable. The rails app does not destroy or change anything in that directory, it only writes to it.

# Development

## Deploying
- Push a commit.
- ssh into the server and change into the `postcard` directory
- pull the commit
- IF the environment variables have changed, ensure you amend these on disk before running the next steps
- `docker-compose down` to stop the service
- `docker-compose build` to push a new image
- `docker-compose up -d` to start it again in the background

If you need to manually update the docker resources:
- `docker ps -a` to find the container SHA
- `docker stop <SHA>` to stop it
- `docker rm <SHA>` to remove the container
- `docker image ls -a` to find the image SHA
- `docker rmi <SHA>` to remove the image

## Logs
On the server box, `docker logs <SHA>` of a container to see the logs

## Tasks and console
To run a rake task or some other command, like a rails console, on the server box, run `docker-compose run web $command$`.
