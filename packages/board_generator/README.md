# Board Generator

Package used to experiment with the board generation process.

## 📝 Getting a list of words

To generate a board, you need a set of words and clues that will be used as an input. Create a `words.csv` file inside the `tool` directory with the following format:

```none
word,clue
flutter,"Open source framework to build multi-platform applications"
firebase,"Mobile and web app development platform by Google"
```

If you need some inspiration, you can always [ask gemini](https://g.co/gemini/share/488086554d89) for help.

## 🧩 Generating a board

You can either generate a symmetrical crossword or an asymmetrical one by running its corresponding script from the `tool` directory.

```bash
dart asymmetrical_generation.dart
```

You can customize the size of the generated board by updating the `bounds` parameter in the `Crossword`.

The script will generate two outputs, a visual representation of the crossword in `asymmetrical_crossword.txt` and a csv file (`board_asymmetrical.txt`) with the position, direction, words and clues for the generated board. The csv is ready to be used by the `board_uploader` package to store the new board in firestore.
