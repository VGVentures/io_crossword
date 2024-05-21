/** Keep in mind that this file is not a real javascript file, it is a template
 * that will be processed by the build system to generate the final javascript
 * file. Therefore, we use the {@link https://mustache.github.io/mustache.5.html mustache syntax} to inject
 * values and you might see some linter errors in this file.
 */

{{flutter_js}}
{{flutter_build_config}}

const cookieBar = document.querySelector("#cookie-bar");
const cookieBarButton = document.querySelector("#confirm-cookies");
const splashCopy = document.querySelector("#splash_copy");

const additionalScripts = [];

let cookiesAcceptanceCompleter;
let hasUserAcceptedCookies = new Promise((resolve) => {
  cookiesAcceptanceCompleter = resolve;
});

cookieBarButton.addEventListener("click", () => {
  console.log("cookieBarButton clicked");
  cookieBar.remove();
  cookiesAcceptanceCompleter();
});

window.addEventListener("load", (event) => {
  _flutter.loader.load({
    serviceWorkerSettings: {
      serviceWorkerVersion: {{flutter_service_worker_version}},
    },
    onEntrypointLoaded: async function (engineInitializer) {
      const appRunner = await engineInitializer.initializeEngine();
      await hasUserAcceptedCookies;

      window.addEventListener("flutter-first-frame", function () {
        splashCopy.remove();
        document.body.classList.remove("loading-mode");
      });

      await appRunner.runApp();
    },
  });
});
