---
name: error-triage
description: Read, resolve and mute the production errors this app reports to errors.joshvince.site. Use when the app is throwing in production, when the user asks what errors have come in, when the user asks you to quiet an error, or after fixing an error that this app reported.
---

# Error triage

This app posts its errors to `https://errors.joshvince.site`. You can read them, resolve them and mute them yourself through its API, so nobody has to paste stack traces to you.

## Auth

Every request needs the app's server-side error token:

```
Authorization: Bearer <token>
```

It is the same token the app's server reporter posts with. Find it where the reporter is configured: Rails credentials (`error_tokens`), an env var, or the Kamal secrets. It is a private credential. Never print it, log it, commit it, or put it in a browser bundle.

The token only ever returns its own app's issues. A 401 means the token is wrong, or it is the app's browser token, which can report but not read. Do not guess or brute force; ask a human.

## Endpoints

Base URL: `https://errors.joshvince.site`.

### List issues

```
GET /api/issues
```

```jsonc
{
  "app": "vincetagram",
  "issues": [
    {
      "id": 42,
      "app": "vincetagram",
      "error_class": "NoMethodError",
      "message": "undefined method `foo' for nil",
      "occurrences": 137,
      "first_seen_at": "2026-10-20T09:12:44.000Z",
      "last_seen_at": "2026-10-28T07:03:11.000Z",
      "muted_for": 0,
      "state": "active",
      "resolved_at": null,
      "url": "https://errors.joshvince.site/issues/42"
    }
  ]
}
```

Issues are one per app and error class, newest seen first. `occurrences` is the volume: a high count matters more than a low one.

`state` is the **work state** and is `active` or `resolved`. Work the `active` ones; leave the `resolved` ones alone.

`muted_for` is the **notification state** and is independent of `state`. Anything above zero means a human has quietened this issue for that many upcoming occurrences (see [Mute](#mute-the-next-occurrence)). A muted issue is still `active` work; muting is not fixing.

### Read one issue

```
GET /api/issues/:id
```

The same fields as above, plus the most recent events, newest first, up to 20:

```jsonc
{
  "id": 42,
  "error_class": "NoMethodError",
  "events": [
    {
      "occurred_at": "2026-10-28T07:03:11.000Z",
      "environment": "production",
      "message": "undefined method `foo' for nil",
      "stack": ["app/models/user.rb:42", "app/controllers/users_controller.rb:17"],
      "context": {
        "url": "/posts",
        "method": "POST",
        "params": { "controller": "posts", "action": "create" },
        "user_agent": "Mozilla/5.0 ...",
        "host": "toy-projects",
        "revision": "abc1234"
      }
    }
  ]
}
```

Read the newest event for the stack and the request that triggered it. Check `environment`: staging and production share an issue, so a `staging` event is not a production fire.

Errors from a browser reporter have minified stacks with no source maps. They are often unreadable, which is expected. Use the message, URL and params instead.

### Resolve

```
POST /api/issues/:id/resolve
```

No body. `200` and the issue, with `state` set to `resolved`.

Resolve an issue when you have actually fixed it. That is what takes it out of the human's inbox. It is honest rather than absolute: if the same class fires again, the sink reopens the issue and emails from scratch, so a regression you did not catch comes straight back to a person. That is the intended safety net, not a failure of the resolve.

### Mute the next occurrence

```
POST /api/issues/:id/mute
```

No body. `200` and the issue, with `muted_for` set.

This mutes exactly one upcoming occurrence: the next time this class fires it records quietly instead of emailing, and the occurrence after that emails again. It is capped deliberately. Do not look for a way to mute more; a wider mute is a human's decision, made in the UI.

An existing wider mute is left alone. Muting never lowers a count a human set.

## How to work an error

1. Fetch the list and start with the newest and the loudest. Use your judgement: 500 occurrences of one class is a fire, 1 occurrence of a crawler 404 is not.
2. Fetch the detail. Find the failing code with the stack and the request context, reproduce it if you can, write the fix with a test, and open a PR.
3. If you cannot reproduce or fix it, or it looks serious, escalate to a human instead of guessing. Serious means data loss, a broken signup, login or payment, a security or PII problem, or anything that looks like it is burning money. Send them the issue `url` and what you found.
4. When the fix is merged, **resolve** each issue you fixed. Do not mute them: resolve is the signal that the work is done, and it is what keeps the inbox at zero.
5. If something is too noisy to think about and a human needs to decide what to do with it, mute it. Muting defers the noise; it does not claim the work is done.
6. Say in your summary which issues you read, what you changed, and which you resolved or muted.

## Rules

- Resolving is a claim that the bug is fixed. Only resolve an issue you have actually fixed, with a test and a merged change.
- Muting is not fixing. Never mute an issue you have not looked at, and never mute to make a suite of errors go quiet before a human has seen them.
- If a fix is only on a branch, or only deployed to staging, the issue is not resolved yet. Resolve it when the fix is actually in production.
- One mute per issue per pass. A mute in a loop hides nothing from the API: the counter keeps climbing and the next occurrence emails anyway, so looping only makes noise for a person.
- Do not poll the API in a tight loop or on a schedule the user did not ask for.
- The raw payload stays available in the API and the UI whatever the issue's state, so resolving and muting hide nothing from you.
- If the app has no token configured, the sink is not reachable for it yet. Tell the user rather than inventing one.

## Example

```bash
TOKEN="$ERRORS_TOKEN"
curl -sS -H "Authorization: Bearer $TOKEN" https://errors.joshvince.site/api/issues
curl -sS -H "Authorization: Bearer $TOKEN" https://errors.joshvince.site/api/issues/42
curl -sS -X POST -H "Authorization: Bearer $TOKEN" https://errors.joshvince.site/api/issues/42/resolve
curl -sS -X POST -H "Authorization: Bearer $TOKEN" https://errors.joshvince.site/api/issues/42/mute
```
