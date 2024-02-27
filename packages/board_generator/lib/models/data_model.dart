library data_model;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';

part 'data_model.g.dart';

@SerializersFor([Location, Crossword, CrosswordCharacter])

/// The global [Serializers] object.
final Serializers serializers = _$serializers;

///{@template crossword}
/// A crossword puzzle data model.
/// {@endtemplate}
abstract class Crossword implements Built<Crossword, CrosswordBuilder> {
  ///{@macro crossword}
  factory Crossword([void Function(CrosswordBuilder) updates]) = _$Crossword;

  Crossword._();

  /// The serializer for this data model.
  static Serializer<Crossword> get serializer => _$crosswordSerializer;

  /// The list of unused candidate words that can be added to this crossword.
  BuiltList<String> get candidates;

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

    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation =
          location.rebuild((b) => b.across = b.across! + index);
      final target = characters[characterLocation];
      if (target != null) {
        if (target.character != character) return null;
        if (target.acrossWord != null) return null;
      }
    }

    final updated = rebuild((b) => b.acrossWords.addAll({location: word}));
    if (updated.valid) return updated;
    return null;
  }

  /// Adds a word down to the crossword puzzle, if it fits.
  Crossword? addDownWord({required Location location, required String word}) {
    final wordCharacters = word.characters;

    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation =
          location.rebuild((b) => b.down = b.down! + index);
      final target = characters[characterLocation];
      if (target != null) {
        if (target.character != character) return null;
        if (target.downWord != null) return null;
      }
    }

    final updated = rebuild((b) => b.downWords.addAll({location: word}));
    if (updated.valid) return updated;
    return null;
  }

  /// Generates a crossword puzzle by adding words to the board.
  Iterable<Crossword> generate() sync* {
    // Nothing left to do if there are no candidate words
    if (candidates.isEmpty) return;

    // Split out the first word case
    if (downWords.isEmpty && acrossWords.isEmpty) {
      for (final word in candidates) {
        final location = Location(
          (b) => b
            ..across = 0
            ..down = 0,
        );

        yield rebuild((b) => b..candidates.remove(word))
            .addAcrossWord(location: location, word: word)!;
      }
      return;
    }

    // All subsequent words are joined to previous words
    for (final entry in characters.entries.toList()..shuffle()) {
      // ignore locations that already join two words
      if (entry.value.acrossWord != null && entry.value.downWord != null) {
        continue;
      }

      // Filter down the candidate word list to those that contain the letter
      // at the current location
      final filteredCandidates = candidates.rebuild(
        (b) => b.removeWhere(
          (innerWord) => !innerWord.characters.contains(entry.value.character),
        ),
      );

      // Attempt to place the filtered candidate words over the current
      // location as a join point.
      for (final word in filteredCandidates) {
        for (final (index, character) in word.characters.indexed) {
          if (character != entry.value.character) continue;

          if (entry.value.acrossWord != null) {
            // Adding a downWord
            final candidate =
                rebuild((b) => b..candidates.remove(word)).addDownWord(
              location:
                  entry.key.rebuild((b) => b.down = entry.key.down - index),
              word: word,
            );

            if (candidate != null) yield candidate;
          } else {
            // Adding an acrossWord
            final candidate =
                rebuild((b) => b..candidates.remove(word)).addAcrossWord(
              location:
                  entry.key.rebuild((b) => b.across = entry.key.across - index),
              word: word,
            );

            if (candidate != null) yield candidate;
          }
        }
      }
    }
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
        b.characters.updateValue(
          characterLocation,
          (b) => b.rebuild((b) => b.acrossWord = word),
          ifAbsent: () => CrosswordCharacter(
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
}

///{@template location}
/// A location in the crossword puzzle.
/// {@endtemplate}
abstract class Location implements Built<Location, LocationBuilder> {
  ///{@macro location}
  factory Location([void Function(LocationBuilder) updates]) = _$Location;

  Location._();

  /// The serializer for this data model.
  static Serializer<Location> get serializer => _$locationSerializer;

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

  /// The serializer for this data model.
  static Serializer<CrosswordCharacter> get serializer =>
      _$crosswordCharacterSerializer;

  /// The character at this location.
  String get character;

  /// The across word that this character is a part of.
  String? get acrossWord;

  /// The down word that this character is a part of.
  String? get downWord;
}
