{{flutter_js}}
{{flutter_build_config}}

// Everything the engine needs to start comes from this site, never from
// Google's servers (docs/web-deployment.md):
// - CanvasKit, from canvaskit/: the release build passes
//   --no-web-resources-cdn, which sets useLocalCanvasKit in the build config
//   above;
// - fonts the app doesn't bundle, from fonts/ instead of fonts.gstatic.com.
//   CanvasKit always loads Roboto as its default font, and would fetch a Noto
//   font for a character the app's fonts lack (Amiri covers all of its text).
//   scripts/web-build.ts checks that fonts/ has the Roboto this engine asks
//   for.
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  config: {
    fontFallbackBaseUrl: "fonts/",
  },
});
