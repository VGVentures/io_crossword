import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

/// {@template word}
/// A model that represents a word in the crossword.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class Word extends Equatable {
  /// {@macro word}
  const Word({
    required this.id,
    required this.position,
    required this.axis,
    required this.clue,
    required this.answer,
    this.solvedTimestamp,
    this.mascot,
  });

  /// {@macro word}
  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  /// The empty character used in [answer].
  static const emptyCharacter = ' ';

  /// Returns the length of the [answer].
  int get length => answer.length;

  /// Checks if [Word] has been solved.
  bool get isSolved => solvedTimestamp != null;

  /// Unique identifier of the word.
  @JsonKey()
  final String id;

  /// Position of the word starting letter in the board.
  /// The origin is the top left.
  @JsonKey()
  @PointConverter()
  final Point<int> position;

  /// The axis of the word in the board.
  @JsonKey()
  final Axis axis;

  /// The clue to show users when guessing for the first time.
  @JsonKey()
  final String clue;

  /// The word answer to display in the crossword when solved.
  /// If the word is not solved, this value contains [emptyCharacter] with the
  /// value of the length of the word.
  /// If parts of the word is solved it will contain the solved character with
  /// [emptyCharacter] where not solved.
  @JsonKey()
  final String answer;

  /// The timestamp when the word was solved. In milliseconds since epoch.
  /// If the word is not solved, this value is null.
  @JsonKey()
  final int? solvedTimestamp;

  /// The mascot of the user that first solved the word.
  /// If the word is not solved, this value is null.
  @JsonKey()
  final Mascots? mascot;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$WordToJson(this);

  /// Returns a copy of this instance with the given fields replaced with the
  /// new values.
  Word copyWith({
    String? id,
    Point<int>? position,
    Axis? axis,
    String? clue,
    String? answer,
    int? solvedTimestamp,
    Mascots? mascot,
  }) {
    return Word(
      id: id ?? this.id,
      position: position ?? this.position,
      axis: axis ?? this.axis,
      clue: clue ?? this.clue,
      answer: answer ?? this.answer,
      solvedTimestamp: solvedTimestamp ?? this.solvedTimestamp,
      mascot: mascot ?? this.mascot,
    );
  }

  @override
  List<Object?> get props => [
        id,
        position,
        axis,
        clue,
        answer,
        solvedTimestamp,
        mascot,
      ];
}

/// The two possible axis for a word in the board.
enum Axis {
  /// From left to right.
  horizontal,

  /// From top to bottom.
  vertical,
}
