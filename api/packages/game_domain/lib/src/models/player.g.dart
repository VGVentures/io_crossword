// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['id'] as String,
      initials: json['initials'] as String,
      mascot: $enumDecode(_$MascotEnumMap, json['mascot']),
      score: (json['score'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'score': instance.score,
      'streak': instance.streak,
      'initials': instance.initials,
      'mascot': _$MascotEnumMap[instance.mascot]!,
    };

const _$MascotEnumMap = {
  Mascot.dash: 'dash',
  Mascot.sparky: 'sparky',
  Mascot.android: 'android',
  Mascot.dino: 'dino',
};
