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
    required this.length,
    required this.clue,
    this.answer,
    this.solvedTimestamp,
    this.mascot,
  });

  /// {@macro word}
  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

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

  /// The length of the word.
  @JsonKey()
  final int length;

  /// The clue to show users when guessing for the first time.
  @JsonKey()
  final String clue;

  /// The word answer to display in the crossword when solved.
  /// If the word is not solved, this value is null.
  @JsonKey()
  final String? answer;

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
    int? length,
    String? clue,
    String? answer,
    int? solvedTimestamp,
    Mascots? mascot,
  }) {
    return Word(
      id: id ?? this.id,
      position: position ?? this.position,
      axis: axis ?? this.axis,
      length: length ?? this.length,
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
        length,
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
