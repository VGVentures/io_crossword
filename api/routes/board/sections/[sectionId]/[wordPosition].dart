import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

(int, int)? _parseSectionId(String sectionId) {
  final coordsRaw = sectionId.split(',');
  if (coordsRaw.length != 2) {
    return null;
  }

  final x = int.tryParse(coordsRaw[0]);
  final y = int.tryParse(coordsRaw[1]);

  if (x == null || y == null) {
    return null;
  }

  return (x, y);
}

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

  final posSection = _parseSectionId(sectionId);
  final sectionX = posSection?.$1;
  final sectionY = posSection?.$2;

  if (sectionX == null || sectionY == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final posWord = _parseSectionId(wordPosition);
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
    return Response();
  }

  return Response(statusCode: HttpStatus.badRequest);
}
