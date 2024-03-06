// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardPlayer _$LeaderboardPlayerFromJson(Map<String, dynamic> json) =>
    LeaderboardPlayer(
      id: json['id'] as String,
      initials: json['initials'] as String,
      numSolved: json['numSolved'] as int,
    );

Map<String, dynamic> _$LeaderboardPlayerToJson(LeaderboardPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numSolved': instance.numSolved,
      'initials': instance.initials,
    };
