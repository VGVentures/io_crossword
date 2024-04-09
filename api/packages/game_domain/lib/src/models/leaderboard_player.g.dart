// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardPlayer _$LeaderboardPlayerFromJson(Map<String, dynamic> json) =>
    LeaderboardPlayer(
      userId: json['userId'] as String,
      initials: json['initials'] as String,
      score: json['score'] as int,
      streak: json['streak'] as int,
      mascot: $enumDecode(_$MascotsEnumMap, json['mascot']),
    );

Map<String, dynamic> _$LeaderboardPlayerToJson(LeaderboardPlayer instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'score': instance.score,
      'streak': instance.streak,
      'initials': instance.initials,
      'mascot': _$MascotsEnumMap[instance.mascot]!,
    };

const _$MascotsEnumMap = {
  Mascots.dash: 'dash',
  Mascots.sparky: 'sparky',
  Mascots.dino: 'dino',
  Mascots.android: 'android',
};
