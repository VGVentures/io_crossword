# Board Generator

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Crossword board generator.

## Usage 💻

There are two steps in the process to generate a board and have it ready in Firestore:

- Board generation
- Divide board into sections and upload it to Firestore

### Generate the crossword board

Add an `allWords.json` file inside the `assets` folder with all the words that will be used to generate the board with the following structure:

```json
{
    "words":[
        {
            "answer": "alpine",
            "definition": "Relative to high mountains"
        }
    ]
}
```

Then, from the package folder, run:

```sh
dart lib/generate_board.dart
```

The board will be created in `assets/board.txt` and updated until all words are placed in it.

### Dividing the board in sections

Once the board is generated, create the sections and upload them to Firestore by running:

```sh
dart lib/create_sections.dart
```

In case you want to update the sections size, do so in the `create_sections.dart` file before creating the sections.

>Note: When creating the sections you will need a service account to upload them to Firestore. Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the path of your service account.

## Running Tests 🧪

The coverage in this package is not enforced at a 100% due to the nature of testing the algorithm with only a few words.

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
