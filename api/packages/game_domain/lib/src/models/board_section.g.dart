// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSection _$BoardSectionFromJson(Map<String, dynamic> json) => BoardSection(
      id: json['id'] as String,
      position: const PointConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      width: json['width'] as int,
      height: json['height'] as int,
      words: (json['words'] as List<dynamic>)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoardSectionToJson(BoardSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': const PointConverter().toJson(instance.position),
      'width': instance.width,
      'height': instance.height,
      'words': instance.words.map((e) => e.toJson()).toList(),
    };
