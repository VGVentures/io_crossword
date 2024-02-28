import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'board_section.g.dart';

/// {@template board_section}
/// A model that represents a board section with all the words that
/// are contained.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class BoardSection extends Equatable {
  /// {@macro board_section}
  const BoardSection({
    required this.id,
    required this.position,
    required this.width,
    required this.height,
    required this.words,
  });

  /// {@macro board_section}
  factory BoardSection.fromJson(Map<String, dynamic> json) =>
      _$BoardSectionFromJson(json);

  /// Unique identifier of the leaderboard player object
  /// and session id for the player.
  @JsonKey()
  final String id;

  /// Position of the board section in the board. The origin is the top left.
  @JsonKey()
  @PointConverter()
  final Point<int> position;

  /// Width of the board section.
  @JsonKey()
  final int width;

  /// Height of the board section.
  @JsonKey()
  final int height;

  /// The words that are contained in this board section.
  @JsonKey()
  final List<Word> words;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$BoardSectionToJson(this);

  @override
  List<Object?> get props => [
        id,
        position,
        width,
        height,
      ];
}
