import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

/// {@template answer}
/// A model that represents an answer to a word.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class Answer extends Equatable {
  /// {@macro answer}
  const Answer({
    required this.id,
    required this.answer,
    required this.sections,
    required this.collidedWords,
  });

  /// {@macro answer}
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  /// Unique identifier of the word.
  ///
  /// Intentionally left out of serialization to avoid redundancy.
  @JsonKey(includeToJson: false)
  final String id;

  /// The answer to the word.
  @JsonKey()
  final String answer;

  /// The sections of the board where the word is located.
  @JsonKey()
  @ListPointConverter()
  final List<Point<int>> sections;

  /// The words that collide with the current [Answer].
  @JsonKey()
  final List<CollidedWord> collidedWords;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  @override
  List<Object?> get props => [id, answer, sections, collidedWords];
}
