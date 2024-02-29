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
When images are uploaded, the Rails server stores them as an ActiveStorage blob.

These blobs are stored in a volume which is defined in the BLOB_STORAGE_ROOT environment variable drawn from the .env file on the outer system which will run docker. The docker-compose.yml file binds the directory (in the container) in the variable to a volume in the server (outside of the container).

This means that blobs will be stored outside the server, and therefore will not be wiped with each deploy. There's no need to gitignore anything on production, although the `tmp/active_storage_blobs` directory is gitignored as this is the default location to save blobs to in development (controlled by the .env file)

### Syncing the images to the archive
Images themselves are sync'd when they are saved from the blob directory to the main archive on the server.

The docker-compose.yml file binds the directory (in the container) in the FILE_STORAGE_ROOT environment variable to a volume in the server (outside of the container). This is where the big archive of photos is.

Inside `Post.rb` there's a method to sync the uploaded image to the directory. It builds a directory based on today's date and then writes to a file in the volume (which is outside the docker container).

The rails app does not destroy or change anything in that directory, it only writes to it.
The Rails app runs using the `rails` user, which has been given write permissions on the outer directory manually from inside the server.

# Development

## Deploying
- Push a commit.
- ssh into the server and change into the `postcard` directory
- pull the commit (see below if you have issues)
- IF the environment variables have changed, ensure you amend these on disk before running the next steps
- `docker compose down` to stop the service
- `docker compose build` to push a new image
- `docker compose up -d` to start it again in the background

If you cannot pull the commit
- check that `keychain` is running
- add the identity of whatever keys are in the `.ssh` directory with ssh-add
- the passphrase is stored where secrets are usually kept

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
