// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      position: const PointConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      axis: $enumDecode(_$AxisEnumMap, json['axis']),
      answer: json['answer'] as String,
      clue: json['clue'] as String,
      solvedTimestamp: json['solvedTimestamp'] as int?,
      mascot: $enumDecodeNullable(_$MascotsEnumMap, json['mascot']),
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'position': const PointConverter().toJson(instance.position),
      'axis': _$AxisEnumMap[instance.axis]!,
      'answer': instance.answer,
      'clue': instance.clue,
      'solvedTimestamp': instance.solvedTimestamp,
      'mascot': _$MascotsEnumMap[instance.mascot],
    };

const _$AxisEnumMap = {
  Axis.horizontal: 'horizontal',
  Axis.vertical: 'vertical',
};

const _$MascotsEnumMap = {
  Mascots.dash: 'dash',
  Mascots.sparky: 'sparky',
  Mascots.dino: 'dino',
  Mascots.android: 'android',
};
