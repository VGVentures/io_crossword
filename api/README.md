# api

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

API used on the I/O Crossword game for Google I/O.
Built with dart_frog.

# Running

To run the API you can use the helper [`start_local_api.sh`][start_api_script] script.

Alternatively, you can manually pass the following arguments:

```sh
FB_APP_ID=APP_ID \
INITIALS_BLACKLIST_ID=DOCUMENT_ID \
FB_STORAGE_BUCKET=FIREBASE_BUCKET_NAME \
GAME_URL=http://localhost:24514 \
HINT_FUNCTION_URL=FIREBASE_FUNCTION_URL \
dart_frog dev
```

# Configure snapshot cors

By default Firebase cloud storage does not allow for accessing images from a cross domain.

To configure it to be able to receive request, do the following:

 - Install and have [gsutil](https://cloud.google.com/storage/docs/gsutil_install) installed.
 - Run, inside this folder: `gsutil cors set cors.json gs://bucket-url.appspot.com`

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[start_api_script]: scripts/start_local_api.sh
