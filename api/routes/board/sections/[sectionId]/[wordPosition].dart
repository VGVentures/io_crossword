import 'dart:io';

import 'package:api/extensions/path_param_to_position.dart';
import 'package:api/extensions/solve_word.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String sectionId,
  String wordPosition,
) async {
  if (context.request.method == HttpMethod.post) {
    return _onPost(context, sectionId, wordPosition);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(
  RequestContext context,
  String sectionId,
  String wordPosition,
) async {
  final crosswordRepository = context.read<CrosswordRepository>();

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

  final section = await crosswordRepository.findSectionByPosition(
    sectionX,
    sectionY,
  );

  if (section == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final word = section.words.firstWhere(
    (element) => element.position.x == wordX && element.position.y == wordY,
  );
  final json = await context.request.json() as Map<String, dynamic>;
  final answer = json['answer'] as String;

  if (answer == word.answer) {
    final solvedWord = word.solveWord();
    final newSection = section.copyWith(
      words: [...section.words..remove(word), solvedWord],
    );
    await crosswordRepository.updateSection(newSection);
    return Response.json(body: {'valid': true});
  }

  return Response.json(body: {'valid': false});
}
