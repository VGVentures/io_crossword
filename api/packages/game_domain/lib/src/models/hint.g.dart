// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hint _$HintFromJson(Map<String, dynamic> json) => Hint(
      question: json['question'] as String,
      response: $enumDecode(_$HintResponseEnumMap, json['response']),
      readableResponse: json['readableResponse'] as String,
    );

Map<String, dynamic> _$HintToJson(Hint instance) => <String, dynamic>{
      'question': instance.question,
      'response': _$HintResponseEnumMap[instance.response]!,
      'readableResponse': instance.readableResponse,
    };

const _$HintResponseEnumMap = {
  HintResponse.yes: 'yes',
  HintResponse.no: 'no',
  HintResponse.notApplicable: 'notApplicable',
};
