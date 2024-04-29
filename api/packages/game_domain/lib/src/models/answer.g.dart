// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as String,
      answer: json['answer'] as String,
      sections: const ListPointConverter()
          .fromJson(json['sections'] as List<Map<String, dynamic>>),
      collidedWords: (json['collidedWords'] as List<dynamic>)
          .map((e) => CollidedWord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answer': instance.answer,
      'sections': const ListPointConverter().toJson(instance.sections),
      'collidedWords': instance.collidedWords.map((e) => e.toJson()).toList(),
    };
