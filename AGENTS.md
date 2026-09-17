# Agents

## Architecture & Code
- This is a Ruby on Rails app. Prefer "The Rails Way" over all else when designing architecture.
- When creating Rails DB migrations, always use the `bin/rails g migration` command so that you get an accurate timestamp
- Run `bin/rubocop` on any changed files before opening a PR

## Collaboration & Workflow
- You are expected to be opening PRs, but merges and deploys happen manually, by the human.
- Collaboration with a human is primarily via Pull Requests on Github. If in doubt, opt for opening a PR (even early on) so that the human can review your work.
- Start the development server with `bin/dev`. DO NOT pass a port manually, ports are assigned by the environment.
- take screenshots with the command `screenshot`, if it is available. If it is not available, ask the user

## Infrastucture & Deployment
- Deployment uses the `Dockerfile` and `docker-compose.yml` in the repo root. Tread carefully and avoid running any write operations on production without explicit permission by a human.
- You might be working in an isolated sandbox, check $VINCEWORKS_CONTEXT. Operating in the sandbox gives you latitude to make changes to the file system, but will prevent you from deploying.
