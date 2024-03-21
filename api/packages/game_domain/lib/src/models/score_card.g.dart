// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreCard _$ScoreCardFromJson(Map<String, dynamic> json) => ScoreCard(
      id: json['id'] as String,
      totalScore: json['totalScore'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      mascot:
          $enumDecodeNullable(_$MascotsEnumMap, json['mascot']) ?? Mascots.dash,
      initials: json['initials'] as String? ?? '',
    );

Map<String, dynamic> _$ScoreCardToJson(ScoreCard instance) => <String, dynamic>{
      'id': instance.id,
      'totalScore': instance.totalScore,
      'streak': instance.streak,
      'mascot': _$MascotsEnumMap[instance.mascot]!,
      'initials': instance.initials,
    };

const _$MascotsEnumMap = {
  Mascots.dash: 'dash',
  Mascots.sparky: 'sparky',
  Mascots.dino: 'dino',
  Mascots.android: 'android',
};
