import 'package:equatable/equatable.dart';
import 'package:game_domain/src/models/mascots.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_player.g.dart';

/// {@template leaderboard_player}
/// A model that represents a player in the leaderboard.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class LeaderboardPlayer extends Equatable {
  /// {@macro leaderboard_player}
  const LeaderboardPlayer({
    required this.userId,
    required this.initials,
    required this.score,
    required this.streak,
    required this.mascot,
  });

  /// {@macro leaderboard_player}
  factory LeaderboardPlayer.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardPlayerFromJson(json);

  /// Creates empty [LeaderboardPlayer].
  static const empty = LeaderboardPlayer(
    userId: '',
    initials: '',
    score: 0,
    streak: 0,
    mascot: Mascots.dash,
  );

  /// Unique identifier of the leaderboard player object
  /// and session id for the player.
  @JsonKey()
  final String userId;

  /// Number of crosswords solved.
  @JsonKey()
  final int score;

  /// Number of streaks.
  @JsonKey()
  final int streak;

  /// Initials of the player.
  @JsonKey()
  final String initials;

  /// The player mascot.
  @JsonKey()
  final Mascots mascot;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$LeaderboardPlayerToJson(this);

  @override
  List<Object?> get props => [userId, score, initials, streak, mascot];
}
