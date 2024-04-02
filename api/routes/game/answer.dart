import 'dart:io';

import 'package:api/extensions/path_param_to_position.dart';
import 'package:collection/collection.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';

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
  final mascotName = json['mascot'] as String?;
  final answer = json['answer'] as String?;

  final mascot = Mascots.values.firstWhereOrNull((e) => e.name == mascotName);

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
    mascot,
    answer,
  );

  return Response.json(body: {'valid': valid});
}
