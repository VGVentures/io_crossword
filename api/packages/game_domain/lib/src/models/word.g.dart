// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      id: json['id'] as String,
      position: const PointConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      axis: $enumDecode(_$AxisEnumMap, json['axis']),
      answer: json['answer'] as String,
      clue: json['clue'] as String,
      hints: (json['hints'] as List<dynamic>).map((e) => e as String).toList(),
      visible: json['visible'] as bool,
      solvedTimestamp: json['solvedTimestamp'] as int?,
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'id': instance.id,
      'position': const PointConverter().toJson(instance.position),
      'axis': _$AxisEnumMap[instance.axis]!,
      'answer': instance.answer,
      'clue': instance.clue,
      'hints': instance.hints,
      'visible': instance.visible,
      'solvedTimestamp': instance.solvedTimestamp,
    };

const _$AxisEnumMap = {
  Axis.horizontal: 'horizontal',
  Axis.vertical: 'vertical',
};
