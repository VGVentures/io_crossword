// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['id'] as String,
      initials: json['initials'] as String,
      mascot: $enumDecode(_$MascotsEnumMap, json['mascot']),
      score: json['score'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
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
