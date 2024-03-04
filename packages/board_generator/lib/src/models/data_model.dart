library data_model;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:characters/characters.dart';

part 'data_model.g.dart';

///{@template crossword}
/// A crossword puzzle data model.
/// {@endtemplate}
abstract class Crossword implements Built<Crossword, CrosswordBuilder> {
  ///{@macro crossword}
  factory Crossword([void Function(CrosswordBuilder) updates]) = _$Crossword;

  Crossword._();

  /// The list of unused candidate words that can be added to this crossword.
  BuiltList<String> get candidates;

  /// The list of candidate locations to process.
  BuiltList<Location> get candidateLocations;

  /// The list of down words, by their starting point location
  BuiltMap<Location, String> get downWords;

  /// The list of across words, by their starting point location
  BuiltMap<Location, String> get acrossWords;

  /// The characters by location. Useful for displaying the crossword,
  /// or checking the proposed solution.
  BuiltMap<Location, CrosswordCharacter> get characters;

  /// Checks if this crossword is valid.
  bool get valid {
    for (final entry in characters.entries) {
      final location = entry.key;
      final character = entry.value;

      // All characters must be a part of an across or down word.
      if (character.acrossWord == null && character.downWord == null) {
        return false;
      }

      // Characters above and below this character must be related
      // by a vertical word
      final characterNorth =
          characters[location.rebuild((b) => b..down = location.down - 1)];
      if (characterNorth != null) {
        if (character.downWord == null) return false;
        if (characterNorth.downWord != character.downWord) return false;
      }

      final characterSouth =
          characters[location.rebuild((b) => b..down = location.down + 1)];
      if (characterSouth != null) {
        if (character.downWord == null) return false;
        if (characterSouth.downWord != character.downWord) return false;
      }

      // Characters to the left and right of this character must be
      // related by a horizontal word
      final characterEast =
          characters[location.rebuild((b) => b..across = location.across - 1)];
      if (characterEast != null) {
        if (character.acrossWord == null) return false;
        if (characterEast.acrossWord != character.acrossWord) return false;
      }

      final characterWest =
          characters[location.rebuild((b) => b..across = location.across + 1)];
      if (characterWest != null) {
        if (character.acrossWord == null) return false;
        if (characterWest.acrossWord != character.acrossWord) return false;
      }
    }

    return true;
  }

  /// Adds a word across to the crossword puzzle, if it fits.
  Crossword? addAcrossWord({required Location location, required String word}) {
    final wordCharacters = word.characters;
    final characterLocations = <Location>[];

    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation =
          location.rebuild((b) => b.across = b.across! + index);
      characterLocations.add(characterLocation);
      final target = characters[characterLocation];
      if (target != null) {
        if (target.character != character) return null;
        if (target.acrossWord != null) return null;
      }
    }

    final updated = rebuild(
      (b) => b
        ..acrossWords.addAll({location: word})
        ..candidateLocations.addAll(characterLocations),
    );
    if (updated.valid) return updated;
    return null;
  }

  /// Adds a word down to the crossword puzzle, if it fits.
  Crossword? addDownWord({required Location location, required String word}) {
    final wordCharacters = word.characters;
    final characterLocations = <Location>[];

    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation =
          location.rebuild((b) => b.down = b.down! + index);
      characterLocations.add(characterLocation);
      final target = characters[characterLocation];
      if (target != null) {
        if (target.character != character) return null;
        if (target.downWord != null) return null;
      }
    }

    final updated = rebuild(
      (b) => b
        ..downWords.addAll({location: word})
        ..candidateLocations.addAll(characterLocations),
    );
    if (updated.valid) return updated;
    return null;
  }

  /// Generates a crossword puzzle by adding words to the board.
  Crossword generate() {
    // Nothing left to do if there are no candidate words
    if (candidates.isEmpty) return this;

    // Split out the first word case
    if (downWords.isEmpty && acrossWords.isEmpty) {
      for (final word in candidates) {
        final location = Location(
          (b) => b
            ..across = 0
            ..down = 0,
        );

        return rebuild((b) => b..candidates.remove(word))
            .addAcrossWord(location: location, word: word)!;
      }
      return this;
    }

    const radius = 5;
    const maxNeighbors = 20;
    // Use the locations that have a higher probability of fitting a word.
    // Keep the locations that have less characters around them.
    final filteredLocations = candidateLocations.rebuild(
      (b) => b.removeWhere((e) {
        final neighbors = <CrosswordCharacter>[];
        for (var i = e.across - radius; i <= e.across + radius; i++) {
          for (var j = e.down - radius; j <= e.down + radius; j++) {
            final location = Location(
              (b) => b
                ..across = i
                ..down = j,
            );
            final character = characters[location];
            if (character != null) {
              neighbors.add(character);
            }
          }
        }
        return neighbors.length > maxNeighbors;
      }),
    );

    // All subsequent words are joined to previous words
    var locations = filteredLocations.rebuild((b) => b.shuffle());
    while (locations.isNotEmpty) {
      final location = locations.first;
      locations = locations.rebuild((b) => b.remove(location));
      final target = characters[location]!;

      // ignore locations that already join two words
      if (target.acrossWord != null && target.downWord != null) {
        continue;
      }

      // Skip locations that have neighbors that join two words
      final characterEast =
          characters[location.rebuild((b) => b..across = location.across + 1)];
      if (characterEast != null && characterEast.downWord != null) {
        continue;
      }
      final characterWest =
          characters[location.rebuild((b) => b..across = location.across - 1)];
      if (characterWest != null && characterWest.downWord != null) {
        continue;
      }
      final characterNorth =
          characters[location.rebuild((b) => b..down = location.down - 1)];
      if (characterNorth != null && characterNorth.acrossWord != null) {
        continue;
      }
      final characterSouth =
          characters[location.rebuild((b) => b..down = location.down + 1)];
      if (characterSouth != null && characterSouth.acrossWord != null) {
        continue;
      }

      // Get the maximum word length that can be placed at this location
      final (wordEnd, wordStart, letters) = _getMaxWordLength(location);
      final maxWordLength = wordEnd - wordStart;

      // Filter down the candidate word list to those that contain the letter
      // at the current location
      final filteredCandidates = candidates.rebuild(
        (b) => b.where(
          (innerWord) =>
              innerWord.characters.contains(target.character) &&
              innerWord.length <= maxWordLength &&
              innerWord.characters.containsAll(letters.join().characters),
        ),
      );

      // Attempt to place the filtered candidate words over the current
      // location as a join point.
      for (final word in filteredCandidates) {
        for (final (index, character) in word.characters.indexed) {
          if (character != target.character) continue;

          if (target.acrossWord != null) {
            // Adding a downWord
            final candidate = rebuild(
              (b) => b
                ..candidates.remove(word)
                ..candidateLocations.replace(locations),
            ).addDownWord(
              location: location.rebuild((b) => b.down = location.down - index),
              word: word,
            );

            if (candidate != null) return candidate;
          } else {
            // Adding an acrossWord
            final candidate = rebuild(
              (b) => b
                ..candidates.remove(word)
                ..candidateLocations.replace(locations),
            ).addAcrossWord(
              location:
                  location.rebuild((b) => b.across = location.across - index),
              word: word,
            );

            if (candidate != null) return candidate;
          }
        }
      }
    }
    return this;
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _fillCharacters(CrosswordBuilder b) {
    b.characters.clear();

    for (final entry in b.acrossWords.build().entries) {
      final location = entry.key;
      final word = entry.value;
      for (final (idx, character) in word.characters.indexed) {
        final characterLocation =
            location.rebuild((b) => b..across = location.across + idx);
        b.characters.putIfAbsent(
          characterLocation,
          () => CrosswordCharacter(
            (b) => b
              ..acrossWord = word
              ..character = character,
          ),
        );
      }
    }

    for (final entry in b.downWords.build().entries) {
      final location = entry.key;
      final word = entry.value;
      for (final (idx, character) in word.characters.indexed) {
        final characterLocation =
            location.rebuild((b) => b..down = location.down + idx);
        b.characters.updateValue(
          characterLocation,
          (b) => b.rebuild((b) => b.downWord = word),
          ifAbsent: () => CrosswordCharacter(
            (b) => b
              ..downWord = word
              ..character = character,
          ),
        );
      }
    }
  }

  (int, int, Set<String>) _getMaxWordLength(Location location) {
    final target = characters[location]!;
    if (target.acrossWord != null) {
      final (startBoundary, startLetters) = _getDownStartBoundary(location);
      final (endBoundary, endLetters) = _getDownEndBoundary(location);
      final letters = startLetters.union(endLetters);
      return (endBoundary, startBoundary, letters);
    } else {
      final (startBoundary, startLetters) = _getAcrossStartBoundary(location);
      final (endBoundary, endLetters) = _getAcrossEndBoundary(location);
      final letters = startLetters.union(endLetters);
      return (endBoundary, startBoundary, letters);
    }
  }

  (int, Set<String>) _getDownStartBoundary(Location location) {
    final letters = <String>{};
    var startBoundary = location.down;
    final down = location.down;
    for (var i = down; i >= down - 20; i--) {
      final westTarget = characters[location.rebuild(
        (b) => b
          ..down = i
          ..across = location.across - 1,
      )];
      final target = characters[location.rebuild((b) => b..down = i - 1)];
      final eastTarget = characters[location.rebuild(
        (b) => b
          ..down = i
          ..across = location.across + 1,
      )];

      // Avoid adding a word parallel to another or that extends another word
      if ((westTarget?.downWord != null) ||
          (target?.downWord != null) ||
          (eastTarget?.downWord != null)) break;

      final northWestTarget = characters[location.rebuild(
        (b) => b
          ..down = i - 1
          ..across = location.across - 1,
      )];
      final northEastTarget = characters[location.rebuild(
        (b) => b
          ..down = i - 1
          ..across = location.across + 1,
      )];

      // Avoid adding a word that extends other word by one character
      final hasDiagonalNeighbor = (northWestTarget?.acrossWord != null) ||
          (northEastTarget?.acrossWord != null);
      if (hasDiagonalNeighbor && (target?.acrossWord == null)) {
        break;
      }

      // If the target contains a character, add it to the list of letters
      // that can be used to filter the candidate words
      final distance = (down - i).abs();
      if ((target != null) && (distance < 4)) {
        letters.add(target.character);
      }
      startBoundary = i;
    }
    return (startBoundary, letters);
  }

  (int, Set<String>) _getDownEndBoundary(Location location) {
    final letters = <String>{};
    var endBoundary = location.down;
    final down = location.down;
    for (var i = down; i <= down + 20; i++) {
      final westTarget = characters[location.rebuild(
        (b) => b
          ..down = i
          ..across = location.across - 1,
      )];
      final target = characters[location.rebuild((b) => b..down = i + 1)];
      final eastTarget = characters[location.rebuild(
        (b) => b
          ..down = i
          ..across = location.across + 1,
      )];

      // Avoid adding a word parallel to another or that extends another word
      if ((westTarget?.downWord != null) ||
          (target?.downWord != null) ||
          (eastTarget?.downWord != null)) break;

      final southEastTarget = characters[location.rebuild(
        (b) => b
          ..down = i + 1
          ..across = location.across + 1,
      )];
      final southWestTarget = characters[location.rebuild(
        (b) => b
          ..down = i + 1
          ..across = location.across - 1,
      )];

      // Avoid adding a word that extends other word by one character
      final hasDiagonalNeighbor = (southEastTarget?.acrossWord != null) ||
          (southWestTarget?.acrossWord != null);
      if (hasDiagonalNeighbor && (target?.acrossWord == null)) {
        break;
      }

      // If the target contains a character, add it to the list of letters
      // that can be used to filter the candidate words
      final distance = (down - i).abs();
      if ((target != null) && (distance < 4)) {
        letters.add(target.character);
      }
      endBoundary = i;
    }
    return (endBoundary, letters);
  }

  (int, Set<String>) _getAcrossStartBoundary(Location location) {
    final letters = <String>{};
    var startBoundary = location.across;
    final across = location.across;
    for (var i = across; i >= across - 20; i--) {
      final northTarget = characters[location.rebuild(
        (b) => b
          ..across = i
          ..down = location.down - 1,
      )];
      final target = characters[location.rebuild((b) => b..across = i - 1)];
      final southTarget = characters[location.rebuild(
        (b) => b
          ..across = i
          ..down = location.down + 1,
      )];

      // Avoid adding a word parallel to another or that extends another word
      if ((northTarget?.acrossWord != null) ||
          (target?.acrossWord != null) ||
          (southTarget?.acrossWord != null)) break;

      final northWestTarget = characters[location.rebuild(
        (b) => b
          ..across = i - 1
          ..down = location.down - 1,
      )];
      final southWestTarget = characters[location.rebuild(
        (b) => b
          ..across = i - 1
          ..down = location.down + 1,
      )];

      // Avoid adding a word that extends other word by one character
      final hasDiagonalNeighbor = (northWestTarget?.downWord != null) ||
          (southWestTarget?.downWord != null);
      if (hasDiagonalNeighbor && (target?.downWord == null)) {
        break;
      }

      // If the target contains a character, add it to the list of letters
      // that can be used to filter the candidate words
      final distance = (across - i).abs();
      if ((target != null) && (distance < 4)) {
        letters.add(target.character);
      }
      startBoundary = i;
    }
    return (startBoundary, letters);
  }

  (int, Set<String>) _getAcrossEndBoundary(Location location) {
    final letters = <String>{};
    var endBoundary = location.across;
    final across = location.across;
    for (var i = across; i <= across + 20; i++) {
      final northTarget = characters[location.rebuild(
        (b) => b
          ..across = i
          ..down = location.down - 1,
      )];
      final target = characters[location.rebuild((b) => b..across = i + 1)];
      final southTarget = characters[location.rebuild(
        (b) => b
          ..across = i
          ..down = location.down + 1,
      )];

      // Avoid adding a word parallel to another or that extends another word
      if ((northTarget?.acrossWord != null) ||
          (target?.acrossWord != null) ||
          (southTarget?.acrossWord != null)) break;
      final northEastTarget = characters[location.rebuild(
        (b) => b
          ..across = i + 1
          ..down = location.down - 1,
      )];
      final southEastTarget = characters[location.rebuild(
        (b) => b
          ..across = i + 1
          ..down = location.down + 1,
      )];

      // Avoid adding a word that extends other word by one character
      final hasDiagonalNeighbor = (northEastTarget?.downWord != null) ||
          (southEastTarget?.downWord != null);
      if (hasDiagonalNeighbor && (target?.downWord == null)) {
        break;
      }

      // If the target contains a character, add it to the list of letters
      // that can be used to filter the candidate words
      final distance = (across - i).abs();
      if ((target != null) && (distance < 4)) {
        letters.add(target.character);
      }
      endBoundary = i;
    }
    return (endBoundary, letters);
  }
}

///{@template location}
/// A location in the crossword puzzle.
/// {@endtemplate}
abstract class Location implements Built<Location, LocationBuilder> {
  ///{@macro location}
  factory Location([void Function(LocationBuilder) updates]) = _$Location;

  Location._();

  /// The horizontal part of the location.
  int get across;

  /// The vertical part of the location.
  int get down;
}

///{@template crossword_character}
/// A character in the crossword puzzle.
/// {@endtemplate}
abstract class CrosswordCharacter
    implements Built<CrosswordCharacter, CrosswordCharacterBuilder> {
  ///{@macro crossword_character}
  factory CrosswordCharacter([
    void Function(CrosswordCharacterBuilder) updates,
  ]) = _$CrosswordCharacter;

  CrosswordCharacter._();

  /// The character at this location.
  String get character;

  /// The across word that this character is a part of.
  String? get acrossWord;

  /// The down word that this character is a part of.
  String? get downWord;
}
