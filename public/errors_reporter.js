// errors.joshvince.site client reporter. Drop-in, no build step: load this file
// on every page after setting the config global.
//
//   <script>
//     window.ErrorsReporter = { endpoint: "https://errors.joshvince.site",
//                               token: "<app token>", app: "vincetagram",
//                               environment: "production" };
//   </script>
//   <script src="/errors_reporter.js"></script>
//
// environment is optional and defaults to "production".
//
// The endpoint must allow this origin (the Authorization header forces a CORS
// preflight on /notify). Delivery is best-effort: every failure here is
// swallowed so reporting can never break the page.
(function () {
  "use strict";

  var config = window.ErrorsReporter;
  if (!config || !config.endpoint || !config.token || !config.app || !window.fetch) return;

  function context() {
    return { url: location.href, user_agent: navigator.userAgent, host: location.host };
  }

  function stackLines(stack) {
    return stack ? String(stack).split("\n") : [];
  }

  function report(errorClass, message, stack) {
    var payload = {
      app: config.app,
      environment: config.environment || "production",
      error_class: errorClass,
      message: message,
      stack: stackLines(stack),
      context: context()
    };

    fetch(config.endpoint + "/notify", {
      method: "POST",
      keepalive: true,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + config.token
      },
      body: JSON.stringify(payload)
    }).catch(function () {});
  }

  // addEventListener rather than assigning window.onerror: it composes with the
  // page's own handler instead of replacing it.
  window.addEventListener("error", function (event) {
    // Resource (img/script) load failures land here too, with neither field set.
    if (!event.error && !event.message) return;

    var error = event.error || {};
    report(error.name || "Error", error.message || event.message, error.stack);
  });

  window.addEventListener("unhandledrejection", function (event) {
    var reason = event.reason;
    if (reason instanceof Error) {
      report(reason.name || "Error", reason.message, reason.stack);
    } else {
      report("UnhandledRejection", String(reason), null);
    }
  });
})();
