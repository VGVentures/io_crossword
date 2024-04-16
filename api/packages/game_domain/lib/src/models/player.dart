import 'package:equatable/equatable.dart';
import 'package:game_domain/src/models/mascots.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

/// {@template leaderboard_player}
/// A model that represents a player in the leaderboard.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class Player extends Equatable {
  /// {@macro leaderboard_player}
  const Player({
    required this.id,
    required this.initials,
    required this.mascot,
    this.score = 0,
    this.streak = 0,
  });

  /// {@macro leaderboard_player}
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Creates empty [Player].
  static const empty = Player(
    id: '',
    initials: '',
    mascot: Mascots.dash,
  );

  /// Unique identifier of the leaderboard player object
  /// and session id for the player.
  @JsonKey(includeToJson: false)
  final String id;

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

  /// Returns a copy of [Player] this instance with the
  /// provided fields.
  Player copyWith({
    String? id,
    String? initials,
    Mascots? mascot,
    int? score,
    int? streak,
  }) {
    return Player(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      mascot: mascot ?? this.mascot,
      score: score ?? this.score,
      streak: streak ?? this.streak,
    );
  }

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  @override
  List<Object?> get props => [id, score, initials, streak, mascot];
}
