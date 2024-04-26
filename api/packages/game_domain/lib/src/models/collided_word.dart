import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collided_word.g.dart';

/// {@template collided_word}
/// A model that represents collision of a word incating the [wordId], the
/// [position] of the character and the [character].
/// {@endtemplate}
@JsonSerializable()
class CollidedWord extends Equatable {
  /// {@macro collided_word}
  const CollidedWord({
    required this.wordId,
    required this.position,
    required this.character,
  });

  /// {@macro collided_word}
  factory CollidedWord.fromJson(Map<String, dynamic> json) =>
      _$CollidedWordFromJson(json);

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$CollidedWordToJson(this);

  /// The id of [Word].
  @JsonKey()
  final String wordId;

  /// The position of the character where it collided.
  /// First character 0, second character 1, etc.
  @JsonKey()
  final int position;

  /// The character that collided.
  @JsonKey()
  final String character;

  @override
  List<Object?> get props => [wordId, position, character];
}
