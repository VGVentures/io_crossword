import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'board_section.g.dart';

/// {@template board_section}
/// A model that represents a board section with all the words that
/// it contains.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class BoardSection extends Equatable {
  /// {@macro board_section}
  const BoardSection({
    required this.id,
    required this.position,
    required this.size,
    required this.words,
    required this.borderWords,
  });

  /// {@macro board_section}
  factory BoardSection.fromJson(Map<String, dynamic> json) =>
      _$BoardSectionFromJson(json);

  /// Unique identifier of board section.
  ///
  /// Intentionally left out of serialization to avoid redundancy.
  @JsonKey(includeToJson: false)
  final String id;

  /// Position of the board section in the board. The origin is the top left.
  @JsonKey()
  @PointConverter()
  final Point<int> position;

  /// Size of the squared board section.
  @JsonKey()
  final int size;

  /// The words that start in this board section.
  @JsonKey()
  final List<Word> words;

  /// The words that end in this board section, but don't start in it.
  @JsonKey()
  final List<Word> borderWords;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$BoardSectionToJson(this);

  BoardSection copyWith({
    Point<int>? position,
  }) =>
      BoardSection(
        id: id,
        position: position ?? this.position,
        size: size,
        words: words,
        borderWords: borderWords,
      );

  @override
  List<Object?> get props => [
        id,
        position,
        size,
        words,
        borderWords,
      ];
}
