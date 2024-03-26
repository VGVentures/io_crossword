import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'score_card.g.dart';

/// {@template score_card}
/// A class representing the user session's score and streak count.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class ScoreCard extends Equatable {
  /// {@macro score_card}
  const ScoreCard({
    required this.id,
    this.totalScore = 0,
    this.streak = 0,
    this.mascot = Mascots.dash,
    this.initials = '',
  });

  /// {@macro score_card}
  factory ScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardFromJson(json);

  /// Unique identifier of the score object and session id for the player.
  @JsonKey()
  final String id;

  /// Total score of the player.
  @JsonKey()
  final int totalScore;

  /// Streak count of the player.
  @JsonKey()
  final int streak;

  /// Mascot of the player.
  @JsonKey()
  final Mascots mascot;

  /// Initials of the player.
  @JsonKey()
  final String initials;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$ScoreCardToJson(this);

  @override
  List<Object?> get props => [
        id,
        totalScore,
        streak,
        mascot,
        initials,
      ];
}
