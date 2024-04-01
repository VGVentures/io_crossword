import 'dart:io';

import 'package:api/extensions/path_param_to_position.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _onPost(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext context) async {
  final crosswordRepository = context.read<CrosswordRepository>();

  final json = await context.request.json() as Map<String, dynamic>;
  final sectionId = json['sectionId'] as String?;
  final wordPosition = json['wordPosition'] as String?;
  final mascot = json['mascot'] as String?;
  final answer = json['answer'] as String?;

  if (sectionId == null ||
      wordPosition == null ||
      mascot == null ||
      answer == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final posSection = sectionId.parseToPosition();
  final sectionX = posSection?.$1;
  final sectionY = posSection?.$2;

  if (sectionX == null || sectionY == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final posWord = wordPosition.parseToPosition();
  final wordX = posWord?.$1;
  final wordY = posWord?.$2;

  if (wordX == null || wordY == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final valid = await crosswordRepository.answerWord(
    sectionX,
    sectionY,
    wordX,
    wordY,
    answer,
  );

  return Response.json(body: {'valid': valid});
}
