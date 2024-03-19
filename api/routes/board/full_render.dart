import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext request) async {
  if (request.request.method == HttpMethod.get) {
    return _onGet(request);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onGet(RequestContext request) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final boardrenderer = request.read<BoardRenderer>();

  final sections = await crosswordRepository.listAllSections();

  final words = sections.expand((section) => section.words);

  final image = await boardrenderer.renderBoardWireframe(words.toList());

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
