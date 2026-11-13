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

## Production errors
- Production errors are reported to errors.joshvince.site as app `vincetagram`. Read `.agents/skills/error-triage/SKILL.md` before reading, fixing, resolving or muting any of them.

## Infrastucture & Deployment
- Deployment uses the `Dockerfile` and `docker-compose.yml` in the repo root. Tread carefully and avoid running any write operations on production without explicit permission by a human.
- You might be working in an isolated sandbox, check $VINCEWORKS_CONTEXT. Operating in the sandbox gives you latitude to make changes to the file system, but will prevent you from deploying.

## Smoke test
- Build the CSS first, since `bin/dev`'s watcher is not running: `bin/rails tailwindcss:build`. Without it every page is a 500 (`tailwind.css` missing).
- Start the server with `bin/rails server -p $PORT` (port from `.env`). Dev uses the `postcard_development` database; `bin/rails db:prepare` first.
- Sign in as `admin@example.com` (an admin in the dev database; create it with `User.create!(name:, email:, admin: true)` if missing). Dev sends no email, so make a link with `bin/rails runner` and open it in the browser:
  `s = Passwordless::Session.create!(authenticatable: User.find_by!(email: 'admin@example.com')); puts Rails.application.routes.url_helpers.confirm_auth_sign_in_url(s, s.token, host: 'localhost', port: ENV.fetch('PORT'))`
- Posts in the dev database made before the update have no file on disk, so their images 404. Ignore those.

Flows:
1. Sign in: `/` redirects to the sign-in page, submit the admin email ("Check your email inbox"), then open the sign-in link and land on the feed.
2. Browse the feed: open a post from the feed and see its photo.
3. Create a post: Feed, New, choose a photo (`public/apple-touch-icon.png`), add a caption, Post, see the caption in the feed.
4. View the new post from the feed.
5. People (admin): list users, open New user (stop before submitting; it would send an invite email), create a sign-in link for a user.
6. Log out: You, Log out, confirm; `/feed` redirects to sign in.
