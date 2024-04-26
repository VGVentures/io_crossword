// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collided_words.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollidedWords _$CollidedWordsFromJson(Map<String, dynamic> json) =>
    CollidedWords(
      section: const PointConverter()
          .fromJson(json['section'] as Map<String, dynamic>),
      words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CollidedWordsToJson(CollidedWords instance) =>
    <String, dynamic>{
      'section': const PointConverter().toJson(instance.section),
      'words': instance.words,
    };
