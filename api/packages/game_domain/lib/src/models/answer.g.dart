// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as String,
      answer: json['answer'] as String,
      section: const PointConverter()
          .fromJson(json['section'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answer': instance.answer,
      'section': const PointConverter().toJson(instance.section),
    };
