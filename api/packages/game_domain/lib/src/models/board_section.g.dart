// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSection _$BoardSectionFromJson(Map<String, dynamic> json) => BoardSection(
      id: json['id'] as String,
      position: const PointConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      size: json['size'] as int,
      words: (json['words'] as List<dynamic>)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
      borderWords: (json['borderWords'] as List<dynamic>)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
      snapshotUrl: json['snapshotUrl'] as String?,
    );

Map<String, dynamic> _$BoardSectionToJson(BoardSection instance) =>
    <String, dynamic>{
      'position': const PointConverter().toJson(instance.position),
      'size': instance.size,
      'words': instance.words.map((e) => e.toJson()).toList(),
      'borderWords': instance.borderWords.map((e) => e.toJson()).toList(),
      'snapshotUrl': instance.snapshotUrl,
    };
