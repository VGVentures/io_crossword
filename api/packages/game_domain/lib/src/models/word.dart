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
    required this.position,
    required this.axis,
    required this.answer,
    required this.clue,
    required this.solvedTimestamp,
    this.mascot,
  }) : id = '$position-$axis';

  /// {@macro word}
  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  /// Unique identifier of the word determined by its position and axis.
  ///
  /// Intentionally left out of serialization to avoid redundancy.
  @JsonKey(includeToJson: false)
  final String id;

  /// Position of the board section in the board. The origin is the top left.
  @JsonKey()
  @PointConverter()
  final Point<int> position;

  /// The axis of the word in the board.
  @JsonKey()
  final Axis axis;

  /// The word answer to display in the crossword when solved.
  @JsonKey()
  final String answer;

  /// The clue to show users when guessing for the first time.
  @JsonKey()
  final String clue;

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
    String? answer,
    String? clue,
    int? solvedTimestamp,
    Mascots? mascot,
  }) {
    return Word(
      position: position ?? this.position,
      axis: axis ?? this.axis,
      answer: answer ?? this.answer,
      clue: clue ?? this.clue,
      solvedTimestamp: solvedTimestamp ?? this.solvedTimestamp,
      mascot: mascot ?? this.mascot,
    );
  }

  @override
  List<Object?> get props => [
        id,
        position,
        axis,
        answer,
        clue,
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
