// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collided_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollidedWord _$CollidedWordFromJson(Map<String, dynamic> json) => CollidedWord(
      wordId: json['wordId'] as String,
      position: (json['position'] as num).toInt(),
      character: json['character'] as String,
      sections: const ListPointConverter()
          .fromJson(json['sections'] as List<Map<String, dynamic>>),
    );

Map<String, dynamic> _$CollidedWordToJson(CollidedWord instance) =>
    <String, dynamic>{
      'wordId': instance.wordId,
      'position': instance.position,
      'character': instance.character,
      'sections': const ListPointConverter().toJson(instance.sections),
    };
