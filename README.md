# I/O Crossword

[![I/O Crossword Header][header]][io_crossword_link]

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

The crossword game built with the [Gemini API][gemini_api_link], [Flutter][flutter_link] and [Firebase][firebase_link] for [Google I/O 2024][google_io_link].

_Built by [Very Good Ventures][very_good_ventures_link] in partnership with Google._

_Created using [Very Good CLI][very_good_cli_link] 🤖_

You can also check out how we used Genkit to power the hints feature in its dedicated [GitHub repository][crossword_backend_repo].

---

## Getting Started 🚀

This project has different entry points.

- `main_local.dart` that targets a local api that should be run first (see how to do it [here][api_readme]).

```sh
$ flutter run -d chrome --target lib/main_local.dart --web-port 24514 --dart-define RECAPTCHA_KEY=<RECAPTCHA_KEY> --dart-define APPCHECK_DEBUG_TOKEN=<APPCHECK_DEBUG_TOKEN>
```

The specified web port is just an example that matches with the one set in the [helper script][start_api_script] to run the api.

- `main_development.dart` that targets the dev api.

```sh
$ flutter run -d chrome --target lib/main_development.dart --dart-define RECAPTCHA_KEY=<RECAPTCHA_KEY> --dart-define APPCHECK_DEBUG_TOKEN=<APPCHECK_DEBUG_TOKEN>
```

- `main_debug.dart` that targets the dev api and adds a visual layer to debug the crossword sections, their position, fps and other items.

```sh
$ flutter run -d chrome --target lib/main_debug.dart --dart-define RECAPTCHA_KEY=<RECAPTCHA_KEY> --dart-define APPCHECK_DEBUG_TOKEN=<APPCHECK_DEBUG_TOKEN>
```

- `main_staging.dart` that targets the staging api.

```sh
$ flutter run -d chrome --target lib/main_staging.dart --dart-define RECAPTCHA_KEY=<RECAPTCHA_KEY>
```

- `main_production.dart` that targets the production api.

```sh
$ flutter run -d chrome --target lib/main_production.dart --dart-define RECAPTCHA_KEY=<RECAPTCHA_KEY>
```

_\*I/O Crossword works on Web._

### Environment variables

The `RECAPTCHA_KEY` and `APPCHECK_DEBUG_TOKEN` environment variables are used to make the app more secure with [Firebase App Check][app_check_link]. You will have to [register your site for reCAPTCHA v3][recaptcha_link] and get a key.

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:io_crossword/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[api_readme]: api/README.md
[very_good_ventures_link]: https://verygood.ventures/
[header]: art/readme_header.png
[io_crossword_link]: https://crossword.withgoogle.com/
[google_io_link]: https://io.google/2024/
[flutter_link]: https://flutter.dev/
[firebase_link]: https://firebase.google.com/
[gemini_api_link]: https://ai.google.dev/
[app_check_link]: https://firebase.google.com/docs/app-check/flutter/default-providers
[recaptcha_link]: https://www.google.com/recaptcha/admin/create
[start_api_script]: api/scripts/start_local_api.sh
[crossword_backend_repo]: https://github.com/VGVentures/io_crossword_backend
