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
    );

Map<String, dynamic> _$LeaderboardPlayerToJson(LeaderboardPlayer instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'score': instance.score,
      'initials': instance.initials,
    };
