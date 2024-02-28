import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

/// {@template word}
/// A model that represents a board section with all the words that
/// are contained.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class Word extends Equatable {
  /// {@macro word}
  const Word({
    required this.id,
    required this.position,
    required this.answer,
    required this.clue,
    required this.hints,
    required this.visible,
    required this.solvedTimestamp,
  });

  /// {@macro word}
  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  /// Unique identifier of the leaderboard player object
  /// and session id for the player.
  @JsonKey()
  final String id;

  /// Position of the board section in the board. The origin is the top left.
  @JsonKey()
  @PointConverter()
  final Point<int> position;

  /// The word answer to display in the crossword when solved.
  @JsonKey()
  final String answer;

  /// The clue to show users when guessing for the first time.
  @JsonKey()
  final String clue;

  /// The hints to show users when asked for more hints.
  @JsonKey()
  final List<String> hints;

  /// Whether the word should be visible or not in the board. Independent of
  /// the word being solved or not.
  /// Every solved word is visible, but not every visible word is solved.
  @JsonKey()
  final bool visible;

  /// The timestamp when the word was solved. In milliseconds since epoch.
  /// If the word is not solved, this value is null.
  @JsonKey()
  final int? solvedTimestamp;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$WordToJson(this);

  @override
  List<Object?> get props => [
        id,
        position,
        answer,
        clue,
        hints,
        visible,
        solvedTimestamp,
      ];
}
