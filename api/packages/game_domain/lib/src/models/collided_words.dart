import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collided_words.g.dart';

/// {@template collided_words}
/// A model that represents an the collisions of a word indicating the
/// [section] of the words and the [words].
/// {@endtemplate}
@JsonSerializable()
class CollidedWords extends Equatable {
  /// {@macro collided_words}
  const CollidedWords({
    required this.section,
    required this.words,
  });

  /// {@macro collided_words}
  factory CollidedWords.fromJson(Map<String, dynamic> json) =>
      _$CollidedWordsFromJson(json);

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$CollidedWordsToJson(this);

  /// The section of the board where the [words] are located.
  @JsonKey()
  @PointConverter()
  final Point<int> section;

  /// The list of the words ids that are colliding.
  @JsonKey()
  final List<String> words;

  @override
  List<Object?> get props => [section, words];
}
